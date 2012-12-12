Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2LLCwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 21:52:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBC2sVAU002427
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 10:54:31 +0800
Message-ID: <50C7F18B.40200@cn.fujitsu.com>
Date: Wed, 12 Dec 2012 10:52:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 9/9] Btrfs: get write access for adding device
References: <50B32ABF.7040803@cn.fujitsu.com> <50B32D98.20309@cn.fujitsu.com>
In-Reply-To: <50B32D98.20309@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comment about this patch?

On mon, 26 Nov 2012 16:51:36 +0800, Miao Xie wrote:
> Without this patch, we can add a device into the R/O fs.
> 
> Steps to reproduce:
>  # mkfs.btrfs -d single -m single <disk0> <disk1>
>  # mount -o ro <disk0> <mnt0>
>  # mount -o ro <disk0> <mnt1>
>  # mount -o remount,rw <mnt0>
>  # umount <mnt0>
>  # btrfs device add <disk1> <mnt1>
> 
> It is because we just check the R/O flag of the super block object.
> It is not enough, because the kernel may set the R/O flag only for
> the mount point. We need invoke
> 
>   mnt_want_write_file()
> 
> to do the full check.
> 
> But, this interface is also used for the seed fs, so I split it to
> two functions, one is used for the common fs, and the other is for
> the seed fs. The detail fix method is following:
> 
> - When we mount a seed fs, we doesn't return -EACCESS. Instead, we just
>   set R/O flag for the super block, and tell the user that "the fs is a
>   seed fs, we mount it on R/O state" by printk
> - If the fs is not a seed fs, we invoke the common device add function,
>   which will call mnt_want_write_file() at first and get write access.
> - If the fs is a seed fs, we will check the flags of the mount point.
>   - If it is R/O, it means the users mount the fs on R/O state on their
>     own initiative, in other words, the users don't want to change anything
>     include adding a new device. So in this case, we will return -EROFS.
>   - If the R/O flag of the mount point is not set, we will make a new fs which
>     is based on the seed fs and add the device into it. At the end of this
>     process, we will clear R/O flag of the super block, and then we can
>     access the new fs freely.
> 
> In this way,
> - We will forbid adding/removing any device to/from a filesystem which is
>   mounted on R/O state(mount -o ro), even it is a seed filesystem. In short,
>   the new process follows the read-only rule more strictly.
> - We can modify the new filesystem which is based on a seed filesystem
>   immediately after it is created, needn't do remount/umount-mount.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c   | 81 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/super.c   |  5 ++--
>  fs/btrfs/volumes.c | 26 ++++++------------
>  fs/btrfs/volumes.h |  3 +-
>  4 files changed, 83 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e6525d1..650d82d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2218,13 +2218,14 @@ out:
>  	return ret;
>  }
>  
> -static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
> +static int btrfs_common_add_device(struct file *file, struct btrfs_root *root,
> +				   const char *devname)
>  {
> -	struct btrfs_ioctl_vol_args *vol_args;
>  	int ret;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
>  
>  	mutex_lock(&root->fs_info->volume_mutex);
>  	if (root->fs_info->balance_ctl) {
> @@ -2233,18 +2234,76 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
>  		goto out;
>  	}
>  
> -	vol_args = memdup_user(arg, sizeof(*vol_args));
> -	if (IS_ERR(vol_args)) {
> -		ret = PTR_ERR(vol_args);
> +	ret = btrfs_init_new_device(root, devname, false);
> +out:
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +	return ret;
> +}
> +
> +static int btrfs_seed_add_device(struct file *file, struct btrfs_root *root,
> +				 const char *devname)
> +{
> +	struct super_block *sb = root->fs_info->sb;
> +	int ret;
> +
> +	sb_start_write(sb);
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	/*
> +	 * Some one may add a new device into a seed fs, and make a
> +	 * new fs, so let's add the device by the common method.
> +	 */
> +	if (!root->fs_info->fs_devices->seeding) {
> +		mutex_unlock(&root->fs_info->volume_mutex);
> +		sb_end_write(sb);
> +		return btrfs_common_add_device(file, root, devname);
> +	}
> +
> +	down_write(&sb->s_umount);
> +	if (file->f_path.mnt->mnt_flags & MNT_READONLY) {
> +		ret = -EROFS;
>  		goto out;
>  	}
>  
> -	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> -	ret = btrfs_init_new_device(root, vol_args->name);
> +	if (root->fs_info->balance_ctl) {
> +		printk(KERN_INFO "btrfs: balance in progress\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
> -	kfree(vol_args);
> +	ret = btrfs_init_new_device(root, devname, true);
> +	if (!ret) {
> +		sb->s_flags &= ~MS_RDONLY;
> +		printk(KERN_INFO "Btrfs created a new filesystem based on "
> +				 "seed filesystem.");
> +	}
>  out:
> +	up_write(&sb->s_umount);
>  	mutex_unlock(&root->fs_info->volume_mutex);
> +	sb_end_write(sb);
> +	return ret;
> +}
> +
> +static long btrfs_ioctl_add_dev(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct btrfs_ioctl_vol_args *vol_args;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	vol_args = memdup_user(arg, sizeof(*vol_args));
> +	if (IS_ERR(vol_args))
> +		return PTR_ERR(vol_args);
> +	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> +
> +	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_SEEDING)
> +		ret = btrfs_seed_add_device(file, root, vol_args->name);
> +	else
> +		ret = btrfs_common_add_device(file, root, vol_args->name);
> +
> +	kfree(vol_args);
>  	return ret;
>  }
>  
> @@ -3800,7 +3859,7 @@ long btrfs_ioctl(struct file *file, unsigned int
>  	case BTRFS_IOC_RESIZE:
>  		return btrfs_ioctl_resize(file, argp);
>  	case BTRFS_IOC_ADD_DEV:
> -		return btrfs_ioctl_add_dev(root, argp);
> +		return btrfs_ioctl_add_dev(file, argp);
>  	case BTRFS_IOC_RM_DEV:
>  		return btrfs_ioctl_rm_dev(file, argp);
>  	case BTRFS_IOC_FS_INFO:
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 915ac14..621fd3c 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1116,8 +1116,9 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		goto error_fs_info;
>  
>  	if (!(flags & MS_RDONLY) && fs_devices->rw_devices == 0) {
> -		error = -EACCES;
> -		goto error_close_devices;
> +		flags |= MS_RDONLY;
> +		printk(KERN_INFO "Btrfs detected seed filesystem, force it to "
> +				 "be READONLY\n");
>  	}
>  
>  	bdev = fs_devices->latest_bdev;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0f5ebb7..66d6dd6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1568,6 +1568,7 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
>  	super_flags = btrfs_super_flags(disk_super) &
>  		      ~BTRFS_SUPER_FLAG_SEEDING;
>  	btrfs_set_super_flags(disk_super, super_flags);
> +	root->fs_info->fs_state &= ~BTRFS_SUPER_FLAG_SEEDING;
>  
>  	return 0;
>  }
> @@ -1648,32 +1649,25 @@ error:
>  	return ret;
>  }
>  
> -int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
> +int btrfs_init_new_device(struct btrfs_root *root, const char *device_path,
> +			  bool seed_fs)
>  {
>  	struct request_queue *q;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_device *device;
>  	struct block_device *bdev;
>  	struct list_head *devices;
> -	struct super_block *sb = root->fs_info->sb;
>  	struct rcu_string *name;
>  	u64 total_bytes;
> -	int seeding_dev = 0;
>  	int ret = 0;
>  
> -	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
> -		return -EROFS;
> -
>  	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
>  				  root->fs_info->bdev_holder);
>  	if (IS_ERR(bdev))
>  		return PTR_ERR(bdev);
>  
> -	if (root->fs_info->fs_devices->seeding) {
> -		seeding_dev = 1;
> -		down_write(&sb->s_umount);
> +	if (seed_fs)
>  		mutex_lock(&uuid_mutex);
> -	}
>  
>  	filemap_write_and_wait(bdev->bd_inode->i_mapping);
>  
> @@ -1740,8 +1734,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	device->mode = FMODE_EXCL;
>  	set_blocksize(device->bdev, 4096);
>  
> -	if (seeding_dev) {
> -		sb->s_flags &= ~MS_RDONLY;
> +	if (seed_fs) {
>  		ret = btrfs_prepare_sprout(root);
>  		BUG_ON(ret); /* -ENOMEM */
>  	}
> @@ -1776,7 +1769,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  				    total_bytes + 1);
>  	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>  
> -	if (seeding_dev) {
> +	if (seed_fs) {
>  		ret = init_first_rw_device(trans, root, device);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, root, ret);
> @@ -1806,9 +1799,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
>  	ret = btrfs_commit_transaction(trans, root);
>  
> -	if (seeding_dev) {
> +	if (seed_fs) {
>  		mutex_unlock(&uuid_mutex);
> -		up_write(&sb->s_umount);
>  
>  		if (ret) /* transaction commit */
>  			return ret;
> @@ -1837,10 +1829,8 @@ error_trans:
>  	kfree(device);
>  error:
>  	blkdev_put(bdev, FMODE_EXCL);
> -	if (seeding_dev) {
> +	if (seed_fs)
>  		mutex_unlock(&uuid_mutex);
> -		up_write(&sb->s_umount);
> -	}
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 53c06af..a76d598 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -279,7 +279,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
>  struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
>  				       u8 *uuid, u8 *fsid);
>  int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
> -int btrfs_init_new_device(struct btrfs_root *root, char *path);
> +int btrfs_init_new_device(struct btrfs_root *root, const char *path,
> +			  bool seed_fs);
>  int btrfs_balance(struct btrfs_balance_control *bctl,
>  		  struct btrfs_ioctl_balance_args *bargs);
>  int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
> 

