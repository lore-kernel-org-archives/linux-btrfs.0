Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51268 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751026AbdAQWrj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:47:39 -0500
Date: Tue, 17 Jan 2017 14:47:01 -0800
From: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/2] btrfs: replace: Use ref counts to avoid destroying
 target device when canceled
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1484693221.27996.0@smtp.office365.com>
In-Reply-To: <20170117011050.18843-2-quwenruo@cn.fujitsu.com>
References: <20170117011050.18843-1-quwenruo@cn.fujitsu.com>
        <20170117011050.18843-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2017 at 5:10 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> When dev-replace and scrub are run at the same time, dev-replace can 
> be
> canceled by scrub. It's quite common for btrfs/069.
> 
> While in that case, target device can be destroyed at cancel time,
> leading to a user-after-free bug:
> 
>      Process A (dev-replace)         |         Process B(scrub)
> ----------------------------------------------------------------------
>                                      |(Any RW is OK)
>                                      |scrub_setup_recheck_block()
>                                      ||- btrfs_map_sblock()
>                                      |   Got a bbio with tgtdev
> btrfs_dev_replace_finishing()        |
> |- btrfs_destory_dev_replace_tgtdev()|
>    |- call_rcu(free_device)          |
>       |- __free_device()             |
>          |- kfree(device)            |
>                                      | Scrub worker:
>                                      | Access bbio->stripes[], which
>                                      | contains tgtdev.
>                                      | This triggers general 
> protection.
> 
> The bug is mostly obvious for RAID5/6 since raid56 choose to keep old
> rbio and rbio->bbio for later steal, this hugely enlarged the race
> window and makes it much easier to trigger the bug.
> 
> This patch introduces 'tgtdev_refs' and 'tgtdev_wait' for btrfs_device
> to wait for all its user released the target device.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/dev-replace.c |  7 ++++++-
>  fs/btrfs/volumes.c     | 36 +++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.h     | 10 ++++++++++
>  3 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 5de280b9ad73..794a6a0bedf2 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -558,7 +558,6 @@ static int btrfs_dev_replace_finishing(struct 
> btrfs_fs_info *fs_info,
>  			  rcu_str_deref(src_device->name),
>  			  src_device->devid,
>  			  rcu_str_deref(tgt_device->name));
> -	tgt_device->is_tgtdev_for_dev_replace = 0;
>  	tgt_device->devid = src_device->devid;
>  	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
>  	memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
> @@ -579,6 +578,12 @@ static int btrfs_dev_replace_finishing(struct 
> btrfs_fs_info *fs_info,
> 
>  	btrfs_dev_replace_unlock(dev_replace, 1);
> 
> +	/*
> +	 * Only change is_tgtdev_for_dev_replace flag after all its
> +	 * users get released.
> +	 */
> +	wait_target_device(tgt_device);
> +	tgt_device->is_tgtdev_for_dev_replace = 0;
>  	btrfs_rm_dev_replace_blocked(fs_info);
> 
>  	btrfs_rm_dev_replace_remove_srcdev(fs_info, src_device);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bb8592e1a364..74a6ee981b78 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2064,6 +2064,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct 
> btrfs_fs_info *fs_info,
>  	WARN_ON(!tgtdev);
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> 
> +	wait_target_device(tgtdev);
>  	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
> 
>  	if (tgtdev->bdev)
> @@ -2598,6 +2599,8 @@ int btrfs_init_dev_replace_tgtdev(struct 
> btrfs_fs_info *fs_info,
>  	device->is_tgtdev_for_dev_replace = 1;
>  	device->mode = FMODE_EXCL;
>  	device->dev_stats_valid = 1;
> +	atomic_set(&device->tgtdev_refs, 0);
> +	init_waitqueue_head(&device->tgtdev_wait);
>  	set_blocksize(device->bdev, 4096);
>  	device->fs_devices = fs_info->fs_devices;
>  	list_add(&device->dev_list, &fs_info->fs_devices->devices);
> @@ -2624,6 +2627,8 @@ void 
> btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info 
> *fs_info,
>  	tgtdev->sector_size = sectorsize;
>  	tgtdev->fs_info = fs_info;
>  	tgtdev->in_fs_metadata = 1;
> +	atomic_set(&tgtdev->tgtdev_refs, 0);
> +	init_waitqueue_head(&tgtdev->tgtdev_wait);
>  }
> 
>  static noinline int btrfs_update_device(struct btrfs_trans_handle 
> *trans,
> @@ -5302,6 +5307,32 @@ static struct btrfs_bio *alloc_btrfs_bio(int 
> total_stripes, int real_stripes)
>  	return bbio;
>  }
> 
> +static void pin_bbio_target_device(struct btrfs_bio *bbio)
> +{
> +	int i;
> +
> +	for (i = 0; i < bbio->num_stripes; i++) {
> +		struct btrfs_device *device = bbio->stripes[i].dev;
> +
> +		if (device->is_tgtdev_for_dev_replace)
> +			atomic_inc(&device->tgtdev_refs);
> +	}
> +}

Can we just do this at the map time?  So when we add a new stripe we go 
ahead and take the ref then, and the same at complete time?  Thanks,

Josef

