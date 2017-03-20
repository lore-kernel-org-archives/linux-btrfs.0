Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32986 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751990AbdCTGa5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 02:30:57 -0400
Subject: Re: [PATCH 5/5] btrfs: replace: Use ref counts to avoid destroying
 target device when canceled
To: <bo.li.liu@oracle.com>
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
 <20170203082023.3577-6-quwenruo@cn.fujitsu.com>
 <20170318021259.GC7719@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b25e0c20-a26f-aeb7-3f8d-663e351a47f2@cn.fujitsu.com>
Date: Mon, 20 Mar 2017 14:30:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170318021259.GC7719@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/18/2017 10:12 AM, Liu Bo wrote:
> On Fri, Feb 03, 2017 at 04:20:23PM +0800, Qu Wenruo wrote:
>> When dev-replace and scrub are run at the same time, dev-replace can be
>> canceled by scrub. It's quite common for btrfs/069.
>>
>> The backtrace would be like:
>> general protection fault: 0000 [#1] SMP
>> Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper [btrfs]
>> RIP: 0010:[<ffffffff813a2fa8>]  [<ffffffff813a2fa8>] generic_make_request_checks+0x198/0x5a0
>> Call Trace:
>>  [<ffffffff813a4cff>] ? generic_make_request+0xcf/0x290
>>  [<ffffffff813a4c54>] generic_make_request+0x24/0x290
>>  [<ffffffff813a4cff>] ? generic_make_request+0xcf/0x290
>>  [<ffffffff813a4f2e>] submit_bio+0x6e/0x120
>>  [<ffffffffa087279d>] ? page_in_rbio+0x4d/0x80 [btrfs]
>>  [<ffffffffa08737d0>] ? rbio_orig_end_io+0x80/0x80 [btrfs]
>>  [<ffffffffa0873e31>] finish_rmw+0x401/0x550 [btrfs]
>>  [<ffffffffa0874fc6>] validate_rbio_for_rmw+0x36/0x40 [btrfs]
>>  [<ffffffffa087504d>] raid_rmw_end_io+0x7d/0x90 [btrfs]
>>  [<ffffffff8139c536>] bio_endio+0x56/0x60
>>  [<ffffffffa07e6e5c>] end_workqueue_fn+0x3c/0x40 [btrfs]
>>  [<ffffffffa08285bf>] btrfs_scrubparity_helper+0xef/0x610 [btrfs]
>>  [<ffffffffa0828b9e>] btrfs_endio_raid56_helper+0xe/0x10 [btrfs]
>>  [<ffffffff810ec8df>] process_one_work+0x2af/0x720
>>  [<ffffffff810ec85b>] ? process_one_work+0x22b/0x720
>>  [<ffffffff810ecd9b>] worker_thread+0x4b/0x4f0
>>  [<ffffffff810ecd50>] ? process_one_work+0x720/0x720
>>  [<ffffffff810ecd50>] ? process_one_work+0x720/0x720
>>  [<ffffffff810f39d3>] kthread+0xf3/0x110
>>  [<ffffffff810f38e0>] ? kthread_park+0x60/0x60
>>  [<ffffffff81857647>] ret_from_fork+0x27/0x40
>>
>> While in that case, target device can be destroyed at cancel time,
>> leading to a user-after-free bug:
>>
>>      Process A (dev-replace)         |         Process B(scrub)
>> ----------------------------------------------------------------------
>>                                      |(Any RW is OK)
>>                                      |scrub_setup_recheck_block()
>>                                      ||- btrfs_map_sblock()
>>                                      |   Got a bbio with tgtdev
>> btrfs_dev_replace_finishing()        |
>> |- btrfs_destory_dev_replace_tgtdev()|
>>    |- call_rcu(free_device)          |
>>       |- __free_device()             |
>>          |- kfree(device)            |
>>                                      | Scrub worker:
>>                                      | Access bbio->stripes[], which
>>                                      | contains tgtdev.
>>                                      | This triggers general protection.
>>
>
> We already have bio_counter to block device replace to avoid
> use-after-free problem, is there any particular reason of not using
> it?

Thanks for pointing this out.

And I found raid56 is already using bio_counter().
But we still trigger such use-after-free bug because bio_counter only 
ensure we won't delete/replace a device when there is still bio running.

Here we are facing a difference situation, where we holds a pointer to 
btrfs_dev which can be freed since there is no pending bios for the 
whole fs.

So here I'm afraid we need refcount based solution for each btrfs_dev 
structure, other than global bio_counter.

Thanks,
Qu
>
> Thanks,
>
> -liubo
>
>> The bug is mostly obvious for RAID5/6 since raid56 choose to keep old
>> rbio and rbio->bbio for later steal, this hugely enlarged the race
>> window and makes it much easier to trigger the bug.
>>
>> This patch introduces 'tgtdev_refs' and 'tgtdev_wait' for btrfs_device
>> to wait for all its user released the target device.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/dev-replace.c |  7 ++++++-
>>  fs/btrfs/volumes.c     | 36 +++++++++++++++++++++++++++++++++++-
>>  fs/btrfs/volumes.h     | 10 ++++++++++
>>  3 files changed, 51 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 5de280b9ad73..794a6a0bedf2 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -558,7 +558,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>  			  rcu_str_deref(src_device->name),
>>  			  src_device->devid,
>>  			  rcu_str_deref(tgt_device->name));
>> -	tgt_device->is_tgtdev_for_dev_replace = 0;
>>  	tgt_device->devid = src_device->devid;
>>  	src_device->devid = BTRFS_DEV_REPLACE_DEVID;
>>  	memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
>> @@ -579,6 +578,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>
>>  	btrfs_dev_replace_unlock(dev_replace, 1);
>>
>> +	/*
>> +	 * Only change is_tgtdev_for_dev_replace flag after all its
>> +	 * users get released.
>> +	 */
>> +	wait_target_device(tgt_device);
>> +	tgt_device->is_tgtdev_for_dev_replace = 0;
>>  	btrfs_rm_dev_replace_blocked(fs_info);
>>
>>  	btrfs_rm_dev_replace_remove_srcdev(fs_info, src_device);
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 3c3c69c0eee4..84db9fb22b7d 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2064,6 +2064,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>>  	WARN_ON(!tgtdev);
>>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>>
>> +	wait_target_device(tgtdev);
>>  	btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
>>
>>  	if (tgtdev->bdev)
>> @@ -2598,6 +2599,8 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>>  	device->is_tgtdev_for_dev_replace = 1;
>>  	device->mode = FMODE_EXCL;
>>  	device->dev_stats_valid = 1;
>> +	atomic_set(&device->tgtdev_refs, 0);
>> +	init_waitqueue_head(&device->tgtdev_wait);
>>  	set_blocksize(device->bdev, 4096);
>>  	device->fs_devices = fs_info->fs_devices;
>>  	list_add(&device->dev_list, &fs_info->fs_devices->devices);
>> @@ -2624,6 +2627,8 @@ void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
>>  	tgtdev->sector_size = sectorsize;
>>  	tgtdev->fs_info = fs_info;
>>  	tgtdev->in_fs_metadata = 1;
>> +	atomic_set(&tgtdev->tgtdev_refs, 0);
>> +	init_waitqueue_head(&tgtdev->tgtdev_wait);
>>  }
>>
>>  static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
>> @@ -5302,6 +5307,32 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
>>  	return bbio;
>>  }
>>
>> +static void pin_bbio_target_device(struct btrfs_bio *bbio)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < bbio->num_stripes; i++) {
>> +		struct btrfs_device *device = bbio->stripes[i].dev;
>> +
>> +		if (device->is_tgtdev_for_dev_replace)
>> +			atomic_inc(&device->tgtdev_refs);
>> +	}
>> +}
>> +
>> +static void unpin_bbio_target_device(struct btrfs_bio *bbio)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < bbio->num_stripes; i++) {
>> +		struct btrfs_device *device = bbio->stripes[i].dev;
>> +
>> +		if (device->is_tgtdev_for_dev_replace) {
>> +			atomic_dec(&device->tgtdev_refs);
>> +			wake_up(&device->tgtdev_wait);
>> +		}
>> +	}
>> +}
>> +
>>  void btrfs_get_bbio(struct btrfs_bio *bbio)
>>  {
>>  	WARN_ON(!atomic_read(&bbio->refs));
>> @@ -5312,8 +5343,10 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
>>  {
>>  	if (!bbio)
>>  		return;
>> -	if (atomic_dec_and_test(&bbio->refs))
>> +	if (atomic_dec_and_test(&bbio->refs)) {
>> +		unpin_bbio_target_device(bbio);
>>  		kfree(bbio);
>> +	}
>>  }
>>
>>  static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>> @@ -5868,6 +5901,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>  		bbio->stripes[0].physical = physical_to_patch_in_first_stripe;
>>  		bbio->mirror_num = map->num_stripes + 1;
>>  	}
>> +	pin_bbio_target_device(bbio);
>>  out:
>>  	if (dev_replace_is_ongoing) {
>>  		btrfs_dev_replace_clear_lock_blocking(dev_replace);
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 24ba6bc3ec34..702361182597 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -149,6 +149,10 @@ struct btrfs_device {
>>  	/* Counter to record the change of device stats */
>>  	atomic_t dev_stats_ccnt;
>>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
>> +
>> +	/* To ensure we wait this target device before destroying it */
>> +	atomic_t tgtdev_refs;
>> +	wait_queue_head_t tgtdev_wait;
>>  };
>>
>>  /*
>> @@ -538,4 +542,10 @@ struct list_head *btrfs_get_fs_uuids(void);
>>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>
>> +static inline void wait_target_device(struct btrfs_device *tgtdev)
>> +{
>> +	if (!tgtdev || !tgtdev->is_tgtdev_for_dev_replace)
>> +		return;
>> +	wait_event(tgtdev->tgtdev_wait, atomic_read(&tgtdev->tgtdev_refs) == 0);
>> +}
>>  #endif
>> --
>> 2.11.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


