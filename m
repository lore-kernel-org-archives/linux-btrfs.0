Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26012 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJDVN3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 17:13:29 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v94LDSsO002948
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 4 Oct 2017 21:13:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v94LDSps014330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 4 Oct 2017 21:13:28 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v94LDSBs028975
        for <linux-btrfs@vger.kernel.org>; Wed, 4 Oct 2017 21:13:28 GMT
Date: Wed, 4 Oct 2017 14:11:54 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
Message-ID: <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003155920.24925-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Write and flush errors are critical errors, upon which the device fd
> must be closed and marked as failed.
>

Can we defer the job of closing device to umount?

We can go mark the device failed and skip it while doing read/write,
and umount can do the cleanup work.

That way we don't need a dedicated thread looping around to detect a
rare situation.

Thanks,

-liubo

> There are two type of device close in btrfs, one, close as part
> of clean up where we shall release the struct btrfs_device and
> or btrfs_fs_devices as well. And the other type which is introduced
> here is where we close the device fd for the reason that it has failed
> and the mounted FS is still present using the other redundant device.
> In this new case we shall keep the failed device's struct btrfs_device
> similar to missing device.
> 
> Further the approach here is to monitor the device statistics and
> trigger the action based on one or more device state.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
> V8: General misc cleanup. Based on v4.14-rc2
> 
>  fs/btrfs/ctree.h   |  2 ++
>  fs/btrfs/disk-io.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.c |  1 +
>  fs/btrfs/volumes.h |  4 +++
>  4 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 5a8933da39a7..bad8fbaff18d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -824,6 +824,7 @@ struct btrfs_fs_info {
>  	struct mutex tree_log_mutex;
>  	struct mutex transaction_kthread_mutex;
>  	struct mutex cleaner_mutex;
> +	struct mutex health_mutex;
>  	struct mutex chunk_mutex;
>  	struct mutex volume_mutex;
>  
> @@ -941,6 +942,7 @@ struct btrfs_fs_info {
>  	struct btrfs_workqueue *extent_workers;
>  	struct task_struct *transaction_kthread;
>  	struct task_struct *cleaner_kthread;
> +	struct task_struct *health_kthread;
>  	int thread_pool_size;
>  
>  	struct kobject *space_info_kobj;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 487bbe4fb3c6..be22104bafbf 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1922,6 +1922,70 @@ static int cleaner_kthread(void *arg)
>  	return 0;
>  }
>  
> +static void btrfs_check_device_fatal_errors(struct btrfs_root *root)
> +{
> +	struct btrfs_device *device;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +
> +	/* Mark devices with write or flush errors as failed. */
> +	mutex_lock(&fs_info->volume_mutex);
> +	list_for_each_entry_rcu(device,
> +			&fs_info->fs_devices->devices, dev_list) {
> +		int c_err;
> +
> +		if (device->failed)
> +			continue;
> +
> +		/* Todo: Skip replace target for now. */
> +		if (device->is_tgtdev_for_dev_replace)
> +			continue;
> +		if (!device->dev_stats_valid)
> +			continue;
> +
> +		c_err = atomic_read(&device->new_critical_errs);
> +		atomic_sub(c_err, &device->new_critical_errs);
> +		if (c_err) {
> +			btrfs_crit_in_rcu(fs_info,
> +				"%s: Fatal write/flush error",
> +				rcu_str_deref(device->name));
> +			btrfs_mark_device_failed(device);
> +		}
> +	}
> +	mutex_unlock(&fs_info->volume_mutex);
> +}
> +
> +static int health_kthread(void *arg)
> +{
> +	struct btrfs_root *root = arg;
> +
> +	do {
> +		/* Todo rename the below function */
> +		if (btrfs_need_cleaner_sleep(root->fs_info))
> +			goto sleep;
> +
> +		if (!mutex_trylock(&root->fs_info->health_mutex))
> +			goto sleep;
> +
> +		if (btrfs_need_cleaner_sleep(root->fs_info)) {
> +			mutex_unlock(&root->fs_info->health_mutex);
> +			goto sleep;
> +		}
> +
> +		/* Check devices health */
> +		btrfs_check_device_fatal_errors(root);
> +
> +		mutex_unlock(&root->fs_info->health_mutex);
> +
> +sleep:
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (!kthread_should_stop())
> +			schedule();
> +		__set_current_state(TASK_RUNNING);
> +	} while (!kthread_should_stop());
> +
> +	return 0;
> +}
> +
>  static int transaction_kthread(void *arg)
>  {
>  	struct btrfs_root *root = arg;
> @@ -1969,6 +2033,7 @@ static int transaction_kthread(void *arg)
>  			btrfs_end_transaction(trans);
>  		}
>  sleep:
> +		wake_up_process(fs_info->health_kthread);
>  		wake_up_process(fs_info->cleaner_kthread);
>  		mutex_unlock(&fs_info->transaction_kthread_mutex);
>  
> @@ -2713,6 +2778,7 @@ int open_ctree(struct super_block *sb,
>  	mutex_init(&fs_info->chunk_mutex);
>  	mutex_init(&fs_info->transaction_kthread_mutex);
>  	mutex_init(&fs_info->cleaner_mutex);
> +	mutex_init(&fs_info->health_mutex);
>  	mutex_init(&fs_info->volume_mutex);
>  	mutex_init(&fs_info->ro_block_group_mutex);
>  	init_rwsem(&fs_info->commit_root_sem);
> @@ -3049,11 +3115,16 @@ int open_ctree(struct super_block *sb,
>  	if (IS_ERR(fs_info->cleaner_kthread))
>  		goto fail_sysfs;
>  
> +	fs_info->health_kthread = kthread_run(health_kthread, tree_root,
> +						"btrfs-health");
> +	if (IS_ERR(fs_info->health_kthread))
> +		goto fail_cleaner;
> +
>  	fs_info->transaction_kthread = kthread_run(transaction_kthread,
>  						   tree_root,
>  						   "btrfs-transaction");
>  	if (IS_ERR(fs_info->transaction_kthread))
> -		goto fail_cleaner;
> +		goto fail_health;
>  
>  	if (!btrfs_test_opt(fs_info, NOSSD) &&
>  	    !fs_info->fs_devices->rotating) {
> @@ -3222,6 +3293,10 @@ int open_ctree(struct super_block *sb,
>  	kthread_stop(fs_info->transaction_kthread);
>  	btrfs_cleanup_transaction(fs_info);
>  	btrfs_free_fs_roots(fs_info);
> +
> +fail_health:
> +	kthread_stop(fs_info->health_kthread);
> +
>  fail_cleaner:
>  	kthread_stop(fs_info->cleaner_kthread);
>  
> @@ -3896,6 +3971,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  
>  	kthread_stop(fs_info->transaction_kthread);
>  	kthread_stop(fs_info->cleaner_kthread);
> +	kthread_stop(fs_info->health_kthread);
>  
>  	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 06e7cf4cef81..18dabd0364bf 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -247,6 +247,7 @@ static struct btrfs_device *__alloc_device(void)
>  	spin_lock_init(&dev->reada_lock);
>  	atomic_set(&dev->reada_in_flight, 0);
>  	atomic_set(&dev->dev_stats_ccnt, 0);
> +	atomic_set(&dev->new_critical_errs, 0);
>  	btrfs_device_data_ordered_init(dev);
>  	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
>  	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 05b150c03995..9328a5d12e78 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -163,6 +163,7 @@ struct btrfs_device {
>  	/* Counter to record the change of device stats */
>  	atomic_t dev_stats_ccnt;
>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
> +	atomic_t new_critical_errs;
>  };
>  
>  /*
> @@ -513,6 +514,9 @@ static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
>  	atomic_inc(dev->dev_stat_values + index);
>  	smp_mb__before_atomic();
>  	atomic_inc(&dev->dev_stats_ccnt);
> +	if (index == BTRFS_DEV_STAT_WRITE_ERRS ||
> +		index == BTRFS_DEV_STAT_FLUSH_ERRS)
> +		atomic_inc(&dev->new_critical_errs);
>  }
>  
>  static inline int btrfs_dev_stat_read(struct btrfs_device *dev,
> -- 
> 2.7.0
> 
