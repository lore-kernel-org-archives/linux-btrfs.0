Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37197 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751554AbdHBTZP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 15:25:15 -0400
Subject: Re: [PATCH 01/14] Btrfs: raid56: add raid56 log via add_dev v2 ioctl
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801161439.13426-2-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b200b004-728a-700b-738f-317d2cd7d5e3@suse.com>
Date: Wed, 2 Aug 2017 22:25:12 +0300
MIME-Version: 1.0
In-Reply-To: <20170801161439.13426-2-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.08.2017 19:14, Liu Bo wrote:
> This introduces add_dev_v2 ioctl to add a device as raid56 journal
> device.  With the help of a journal device, raid56 is able to to get
> rid of potential write holes.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.h                |  6 ++++++
>  fs/btrfs/ioctl.c                | 48 ++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/raid56.c               | 42 ++++++++++++++++++++++++++++++++++++
>  fs/btrfs/raid56.h               |  1 +
>  fs/btrfs/volumes.c              | 26 ++++++++++++++++------
>  fs/btrfs/volumes.h              |  3 ++-
>  include/uapi/linux/btrfs.h      |  3 +++
>  include/uapi/linux/btrfs_tree.h |  4 ++++
>  8 files changed, 125 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 643c70d..d967627 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -697,6 +697,7 @@ struct btrfs_stripe_hash_table {
>  void btrfs_init_async_reclaim_work(struct work_struct *work);
>  
>  /* fs_info */
> +struct btrfs_r5l_log;
>  struct reloc_control;
>  struct btrfs_device;
>  struct btrfs_fs_devices;
> @@ -1114,6 +1115,9 @@ struct btrfs_fs_info {
>  	u32 nodesize;
>  	u32 sectorsize;
>  	u32 stripesize;
> +
> +	/* raid56 log */
> +	struct btrfs_r5l_log *r5log;
>  };
>  
>  static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> @@ -2932,6 +2936,8 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_fs_info *fs_info)
>  
>  static inline void free_fs_info(struct btrfs_fs_info *fs_info)
>  {
> +	if (fs_info->r5log)
> +		kfree(fs_info->r5log);
>  	kfree(fs_info->balance_ctl);
>  	kfree(fs_info->delayed_root);
>  	kfree(fs_info->extent_root);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e176375..3d1ef4d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2653,6 +2653,50 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>  	return ret;
>  }
>  
> +/* identical to btrfs_ioctl_add_dev, but this is with flags */
> +static long btrfs_ioctl_add_dev_v2(struct btrfs_fs_info *fs_info, void __user *arg)
> +{
> +	struct btrfs_ioctl_vol_args_v2 *vol_args;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> +		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> +
> +	mutex_lock(&fs_info->volume_mutex);
> +	vol_args = memdup_user(arg, sizeof(*vol_args));
> +	if (IS_ERR(vol_args)) {
> +		ret = PTR_ERR(vol_args);
> +		goto out;
> +	}
> +
> +	if (vol_args->flags & BTRFS_DEVICE_RAID56_LOG &&
> +	    fs_info->r5log) {
> +		ret = -EEXIST;
> +		btrfs_info(fs_info, "r5log: attempting to add another log device!");
> +		goto out_free;
> +	}
> +
> +	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> +	ret = btrfs_init_new_device(fs_info, vol_args->name, vol_args->flags);
> +	if (!ret) {
> +		if (vol_args->flags & BTRFS_DEVICE_RAID56_LOG) {
> +			ASSERT(fs_info->r5log);
> +			btrfs_info(fs_info, "disk added %s as raid56 log", vol_args->name);
> +		} else {
> +			btrfs_info(fs_info, "disk added %s", vol_args->name);
> +		}
> +	}
> +out_free:
> +	kfree(vol_args);
> +out:
> +	mutex_unlock(&fs_info->volume_mutex);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> +	return ret;
> +}
> +
>  static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
>  {
>  	struct btrfs_ioctl_vol_args *vol_args;
> @@ -2672,7 +2716,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
>  	}
>  
>  	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> -	ret = btrfs_init_new_device(fs_info, vol_args->name);
> +	ret = btrfs_init_new_device(fs_info, vol_args->name, 0);
>  
>  	if (!ret)
>  		btrfs_info(fs_info, "disk added %s", vol_args->name);
> @@ -5539,6 +5583,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_resize(file, argp);
>  	case BTRFS_IOC_ADD_DEV:
>  		return btrfs_ioctl_add_dev(fs_info, argp);
> +	case BTRFS_IOC_ADD_DEV_V2:
> +		return btrfs_ioctl_add_dev_v2(fs_info, argp);
>  	case BTRFS_IOC_RM_DEV:
>  		return btrfs_ioctl_rm_dev(file, argp);
>  	case BTRFS_IOC_RM_DEV_V2:
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index d8ea0eb..2b91b95 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -177,6 +177,25 @@ struct btrfs_raid_bio {
>  	unsigned long *dbitmap;
>  };
>  
> +/* raid56 log */
> +struct btrfs_r5l_log {
> +	/* protect this struct and log io */
> +	struct mutex io_mutex;
> +
> +	/* r5log device */
> +	struct btrfs_device *dev;
> +
> +	/* allocation range for log entries */
> +	u64 data_offset;
> +	u64 device_size;
> +
> +	u64 last_checkpoint;
> +	u64 last_cp_seq;
> +	u64 seq;
> +	u64 log_start;
> +	struct btrfs_r5l_io_unit *current_io;
> +};
> +
>  static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
>  static noinline void finish_rmw(struct btrfs_raid_bio *rbio);
>  static void rmw_work(struct btrfs_work *work);
> @@ -2715,3 +2734,26 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
>  	if (!lock_stripe_add(rbio))
>  		async_missing_raid56(rbio);
>  }
> +
> +int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
> +{
> +	struct btrfs_r5l_log *log;
> +
> +	log = kzalloc(sizeof(*log), GFP_NOFS);
> +	if (!log)
> +		return -ENOMEM;
> +
> +	/* see find_free_dev_extent for 1M start offset */
> +	log->data_offset = 1024ull * 1024;

Please use SZ_1M define from linux/sizes.h

> +	log->device_size = btrfs_device_get_total_bytes(device) - log->data_offset;
> +	log->device_size = round_down(log->device_size, PAGE_SIZE);
> +	log->dev = device;
> +	mutex_init(&log->io_mutex);
> +
> +	cmpxchg(&fs_info->r5log, NULL, log);
> +	ASSERT(fs_info->r5log == log);
> +
> +	trace_printk("r5log: set a r5log in fs_info,  alloc_range 0x%llx 0x%llx",
> +		     log->data_offset, log->data_offset + log->device_size);
> +	return 0;
> +}
> diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
> index 4ee4fe3..0c8bf6a 100644
> --- a/fs/btrfs/raid56.h
> +++ b/fs/btrfs/raid56.h
> @@ -65,4 +65,5 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
>  
>  int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
>  void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info);
> +int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device);
>  #endif
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 017b67d..dafc541 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2313,7 +2313,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path)
> +int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path, const u64 flags)
>  {
>  	struct btrfs_root *root = fs_info->dev_root;
>  	struct request_queue *q;
> @@ -2326,6 +2326,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	u64 tmp;
>  	int seeding_dev = 0;
>  	int ret = 0;
> +	bool is_r5log = (flags & BTRFS_DEVICE_RAID56_LOG);
> +
> +	if (is_r5log)
> +		ASSERT(!fs_info->fs_devices->seeding);
>  
>  	if ((sb->s_flags & MS_RDONLY) && !fs_info->fs_devices->seeding)
>  		return -EROFS;
> @@ -2382,6 +2386,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	q = bdev_get_queue(bdev);
>  	if (blk_queue_discard(q))
>  		device->can_discard = 1;
> +	if (is_r5log)
> +		device->type |= BTRFS_DEV_RAID56_LOG;
>  	device->writeable = 1;
>  	device->generation = trans->transid;
>  	device->io_width = fs_info->sectorsize;
> @@ -2434,11 +2440,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	/* add sysfs device entry */
>  	btrfs_sysfs_add_device_link(fs_info->fs_devices, device);
>  
> -	/*
> -	 * we've got more storage, clear any full flags on the space
> -	 * infos
> -	 */
> -	btrfs_clear_space_info_full(fs_info);
> +	if (!is_r5log) {
> +		/*
> +		 * we've got more storage, clear any full flags on the space
> +		 * infos
> +		 */
> +		btrfs_clear_space_info_full(fs_info);
> +	}
>  
>  	mutex_unlock(&fs_info->chunk_mutex);
>  	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> @@ -2459,6 +2467,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  		goto error_trans;
>  	}
>  
> +	if (is_r5log) {
> +		ret = btrfs_set_r5log(fs_info, device);

Nit: Setting the r5log (in the fsinfo) is only one part of the overall
initialisation of the log device, so why not btrfs_r5log_init or
init_r5log?

> +		if (ret)
> +			goto error_trans;
> +	}
> +
>  	if (seeding_dev) {
>  		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index c7d0fbc..60e347a 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -437,7 +437,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
>  struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
>  				       u8 *uuid, u8 *fsid);
>  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
> -int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
> +int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path,
> +			  const u64 flags);
>  int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  				  const char *device_path,
>  				  struct btrfs_device *srcdev,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index a456e53..be5991f 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -35,6 +35,7 @@ struct btrfs_ioctl_vol_args {
>  #define BTRFS_DEVICE_PATH_NAME_MAX 1024
>  
>  #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
> +#define BTRFS_DEVICE_RAID56_LOG		(1ULL << 4)
>  
>  #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
>  			(BTRFS_SUBVOL_CREATE_ASYNC |	\
> @@ -818,5 +819,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_feature_flags[3])
>  #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
>  				   struct btrfs_ioctl_vol_args_v2)
> +#define BTRFS_IOC_ADD_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 59, \
> +				   struct btrfs_ioctl_vol_args_v2)
>  
>  #endif /* _UAPI_LINUX_BTRFS_H */
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index 10689e1..52fed59 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -347,6 +347,10 @@ struct btrfs_key {
>  	__u64 offset;
>  } __attribute__ ((__packed__));
>  
> +/* dev_item.type */
> +/* #define BTRFS_DEV_REGULAR	0 */

Why is the regular device commented out?

> +#define BTRFS_DEV_RAID56_LOG	(1ULL << 0)
> +
>  struct btrfs_dev_item {
>  	/* the internal btrfs device id */
>  	__le64 devid;
> 
