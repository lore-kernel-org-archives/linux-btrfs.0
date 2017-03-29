Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41510 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755700AbdC2J4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 05:56:42 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] btrfs: track exclusive filesystem operation in flags
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170328124421.30585-1-dsterba@suse.com>
Message-ID: <ac95c9c4-ed2b-3a9f-f763-697bd63db56f@oracle.com>
Date: Wed, 29 Mar 2017 18:01:37 +0800
MIME-Version: 1.0
In-Reply-To: <20170328124421.30585-1-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/28/2017 08:44 PM, David Sterba wrote:
> There are several operations, usually started from ioctls, that cannot
> run concurrently. The status is tracked in
> mutually_exclusive_operation_running as an atomic_t. We can easily track
> the status as one of the per-filesystem flag bits with same
> synchronization guarantees.
>
> The conversion replaces:
>
> * atomic_xchg(..., 1)    ->   test_and_set_bit(FLAG, ...)
> * atomic_set(..., 0)     ->   clear_bit(FLAG, ...)


    Makes sense.

   Reviewed-by: Anand Jain <anand.jain@oracle.com>

    However in the long term do you think its better to have
    BTRFS_FS_EXCL_OP flag in the struct btrfs_fs_devices
    rather than in struct btrfs_fs_info ? because we don't have
    fs_info until device is mounted and in the long term we could
    have a feature where volume can be maintained just after the
    device scan without device being mounted.

Thanks, Anand



> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h       |  7 +++++--
>  fs/btrfs/dev-replace.c |  5 ++---
>  fs/btrfs/ioctl.c       | 33 +++++++++++++++------------------
>  fs/btrfs/volumes.c     |  6 +++---
>  4 files changed, 25 insertions(+), 26 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 29b7fc28c607..2521752c4e4a 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -702,6 +702,11 @@ struct btrfs_delayed_root;
>  #define BTRFS_FS_BTREE_ERR			11
>  #define BTRFS_FS_LOG1_ERR			12
>  #define BTRFS_FS_LOG2_ERR			13
> +/*
> + * Indicate that a whole-filesystem exclusive operation is running
> + * (device replace, resize, device add/delete, balance)
> + */
> +#define BTRFS_FS_EXCL_OP			14
>
>  struct btrfs_fs_info {
>  	u8 fsid[BTRFS_FSID_SIZE];
> @@ -1067,8 +1072,6 @@ struct btrfs_fs_info {
>  	/* device replace state */
>  	struct btrfs_dev_replace dev_replace;
>
> -	atomic_t mutually_exclusive_operation_running;
> -
>  	struct percpu_counter bio_counter;
>  	wait_queue_head_t replace_wait;
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index e653921f05d9..de7b2c897fe0 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -784,8 +784,7 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
>  	}
>  	btrfs_dev_replace_unlock(dev_replace, 1);
>
> -	WARN_ON(atomic_xchg(
> -		&fs_info->mutually_exclusive_operation_running, 1));
> +	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
>  	task = kthread_run(btrfs_dev_replace_kthread, fs_info, "btrfs-devrepl");
>  	return PTR_ERR_OR_ZERO(task);
>  }
> @@ -814,7 +813,7 @@ static int btrfs_dev_replace_kthread(void *data)
>  			(unsigned int)progress);
>  	}
>  	btrfs_dev_replace_continue_on_mount(fs_info);
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>
>  	return 0;
>  }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index dabfc7ac48a6..a29dc3fd7152 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1504,7 +1504,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>  	if (ret)
>  		return ret;
>
> -	if (atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1)) {
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  		mnt_drop_write_file(file);
>  		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  	}
> @@ -1619,7 +1619,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>  	kfree(vol_args);
>  out:
>  	mutex_unlock(&fs_info->volume_mutex);
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  	mnt_drop_write_file(file);
>  	return ret;
>  }
> @@ -2661,7 +2661,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>
> -	if (atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1))
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
>  		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>
>  	mutex_lock(&fs_info->volume_mutex);
> @@ -2680,7 +2680,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __user *arg)
>  	kfree(vol_args);
>  out:
>  	mutex_unlock(&fs_info->volume_mutex);
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  	return ret;
>  }
>
> @@ -2708,7 +2708,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>  	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
>  		return -EOPNOTSUPP;
>
> -	if (atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1)) {
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  		goto out;
>  	}
> @@ -2721,7 +2721,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
>  		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
>  	}
>  	mutex_unlock(&fs_info->volume_mutex);
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>
>  	if (!ret) {
>  		if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID)
> @@ -2752,7 +2752,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>  	if (ret)
>  		return ret;
>
> -	if (atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1)) {
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  		goto out_drop_write;
>  	}
> @@ -2772,7 +2772,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>  		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
>  	kfree(vol_args);
>  out:
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  out_drop_write:
>  	mnt_drop_write_file(file);
>
> @@ -4442,13 +4442,11 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
>  			ret = -EROFS;
>  			goto out;
>  		}
> -		if (atomic_xchg(
> -			&fs_info->mutually_exclusive_operation_running, 1)) {
> +		if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  		} else {
>  			ret = btrfs_dev_replace_by_ioctl(fs_info, p);
> -			atomic_set(
> -			 &fs_info->mutually_exclusive_operation_running, 0);
> +			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  		}
>  		break;
>  	case BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS:
> @@ -4643,7 +4641,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  		return ret;
>
>  again:
> -	if (!atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1)) {
> +	if (!test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  		mutex_lock(&fs_info->volume_mutex);
>  		mutex_lock(&fs_info->balance_mutex);
>  		need_unlock = true;
> @@ -4689,7 +4687,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  	}
>
>  locked:
> -	BUG_ON(!atomic_read(&fs_info->mutually_exclusive_operation_running));
> +	BUG_ON(!test_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
>
>  	if (arg) {
>  		bargs = memdup_user(arg, sizeof(*bargs));
> @@ -4745,11 +4743,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>
>  do_balance:
>  	/*
> -	 * Ownership of bctl and mutually_exclusive_operation_running
> +	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP
>  	 * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
>  	 * or, if restriper was paused all the way until unmount, in
> -	 * free_fs_info.  mutually_exclusive_operation_running is
> -	 * cleared in __cancel_balance.
> +	 * free_fs_info.  The flag is cleared in __cancel_balance.
>  	 */
>  	need_unlock = false;
>
> @@ -4769,7 +4766,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  	mutex_unlock(&fs_info->balance_mutex);
>  	mutex_unlock(&fs_info->volume_mutex);
>  	if (need_unlock)
> -		atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  out:
>  	mnt_drop_write_file(file);
>  	return ret;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 73d56eef5e60..91580cf471e4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3736,7 +3736,7 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
>  	if (ret)
>  		btrfs_handle_fs_error(fs_info, ret, NULL);
>
> -	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  }
>
>  /* Non-zero return value signifies invalidity */
> @@ -3910,7 +3910,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		__cancel_balance(fs_info);
>  	else {
>  		kfree(bctl);
> -		atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
> +		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>  	}
>  	return ret;
>  }
> @@ -4000,7 +4000,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
>  	btrfs_balance_sys(leaf, item, &disk_bargs);
>  	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
>
> -	WARN_ON(atomic_xchg(&fs_info->mutually_exclusive_operation_running, 1));
> +	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
>
>  	mutex_lock(&fs_info->volume_mutex);
>  	mutex_lock(&fs_info->balance_mutex);
>
