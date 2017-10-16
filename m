Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37754 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdJPGJw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 02:09:52 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9G69pnN029349
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9G69pWE019322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:51 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9G69plC021050
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:51 GMT
Subject: Re: [PATCH v8 1/2] btrfs: introduce device dynamic state transition
 to failed
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-2-anand.jain@oracle.com>
 <20171013184728.GE1553@lim.localdomain>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b188312d-f514-5a86-bd32-26472259771a@oracle.com>
Date: Mon, 16 Oct 2017 14:09:44 +0800
MIME-Version: 1.0
In-Reply-To: <20171013184728.GE1553@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/14/2017 02:47 AM, Liu Bo wrote:
> On Tue, Oct 03, 2017 at 11:59:19PM +0800, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> This patch provides helper functions to force a device to failed,
>> and we need it for the following reasons,
>> 1) a. It can be reported that device has failed when it does and
>>     b. Close the device when it goes offline so that blocklayer can
>>        cleanup
>> 2) Identify the candidate for the auto replace
>> 3) Stop further RW to the failing device and
>> 4) A device in the multi device btrfs may fail, but as of now in
>>     some system config whole of btrfs gets unmounted.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> ---
>> V8: General misc cleanup. Based on v4.14-rc2
>>
>>   fs/btrfs/volumes.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/volumes.h |  15 +++++++-
>>   2 files changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 0e8f16c305df..06e7cf4cef81 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -7255,3 +7255,107 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info)
>>   		fs_devices = fs_devices->seed;
>>   	}
>>   }
>> +
>> +static void do_close_device(struct work_struct *work)
>> +{
>> +	struct btrfs_device *device;
>> +
>> +	device = container_of(work, struct btrfs_device, rcu_work);
>> +
>> +	if (device->closing_bdev)
>> +		blkdev_put(device->closing_bdev, device->mode);
>> +
>> +	device->closing_bdev = NULL;
>> +}
>> +
>> +static void btrfs_close_one_device(struct rcu_head *head)
>> +{
>> +	struct btrfs_device *device;
>> +
>> +	device = container_of(head, struct btrfs_device, rcu);
>> +
>> +	INIT_WORK(&device->rcu_work, do_close_device);
>> +	schedule_work(&device->rcu_work);
>> +}
> 
> No need to schedule the job to a worker.

  Right. Will fix it. Thanks.

-Anand


> thanks,
> 
> -liubo
> 
>> +
>> +void btrfs_force_device_close(struct btrfs_device *device)
>> +{
>> +	struct btrfs_fs_info *fs_info;
>> +	struct btrfs_fs_devices *fs_devices;
>> +
>> +	fs_devices = device->fs_devices;
>> +	fs_info = fs_devices->fs_info;
>> +
>> +	btrfs_sysfs_rm_device_link(fs_devices, device);
>> +
>> +	mutex_lock(&fs_devices->device_list_mutex);
>> +	mutex_lock(&fs_devices->fs_info->chunk_mutex);
>> +
>> +	btrfs_assign_next_active_device(fs_devices->fs_info, device, NULL);
>> +
>> +	if (device->bdev)
>> +		fs_devices->open_devices--;
>> +
>> +	if (device->writeable) {
>> +		list_del_init(&device->dev_alloc_list);
>> +		fs_devices->rw_devices--;
>> +	}
>> +	device->writeable = 0;
>> +
>> +	/*
>> +	 * Todo: We have miss-used missing flag all around, and here
>> +	 * too for now. (In the long run I want to keep missing to only
>> +	 * indicate that it was not present when RAID was assembled.)
>> +	 */
>> +	device->missing = 1;
>> +	fs_devices->missing_devices++;
>> +	device->closing_bdev = device->bdev;
>> +	device->bdev = NULL;
>> +
>> +	call_rcu(&device->rcu, btrfs_close_one_device);
>> +
>> +	mutex_unlock(&fs_devices->fs_info->chunk_mutex);
>> +	mutex_unlock(&fs_devices->device_list_mutex);
>> +
>> +	rcu_barrier();
>> +
>> +	btrfs_warn_in_rcu(fs_info, "device %s failed",
>> +				rcu_str_deref(device->name));
>> +
>> +	/*
>> +	 * We lost one/more disk, which means its not as it
>> +	 * was configured by the user. Show mount should show
>> +	 * degraded.
>> +	 */
>> +	btrfs_set_opt(fs_info->mount_opt, DEGRADED);
>> +
>> +	/*
>> +	 * Now having lost one of the device, check if chunk stripe
>> +	 * is incomplete and handle fatal error if needed.
>> +	 */
>> +	if (!btrfs_check_rw_degradable(fs_info))
>> +		btrfs_handle_fs_error(fs_info, -EIO,
>> +				"devices below critical level");
>> +}
>> +
>> +void btrfs_mark_device_failed(struct btrfs_device *dev)
>> +{
>> +	struct btrfs_fs_devices *fs_devices = dev->fs_devices;
>> +
>> +	/* This shouldn't be called if device is already missing */
>> +	if (dev->missing || !dev->bdev)
>> +		return;
>> +	if (dev->failed)
>> +		return;
>> +	dev->failed = 1;
>> +
>> +	/* Last RW device is requested to force close let FS handle it. */
>> +	if (fs_devices->rw_devices == 1) {
>> +		btrfs_handle_fs_error(fs_devices->fs_info, -EIO,
>> +					"Last RW device failed");
>> +		return;
>> +	}
>> +
>> +	/* Point of no return start here. */
>> +	btrfs_force_device_close(dev);
>> +}
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 6108fdfec67f..05b150c03995 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -65,13 +65,26 @@ struct btrfs_device {
>>   	struct btrfs_pending_bios pending_sync_bios;
>>   
>>   	struct block_device *bdev;
>> +	struct block_device *closing_bdev;
>>   
>>   	/* the mode sent to blkdev_get */
>>   	fmode_t mode;
>>   
>>   	int writeable;
>>   	int in_fs_metadata;
>> +	/* missing: device not found at the time of mount */
>>   	int missing;
>> +	/* failed: device confirmed to have experienced critical io failure */
>> +	int failed;
>> +	/*
>> +	* offline: system or user or block layer transport has removed
>> +	* offlined the device which was once present and without going
>> +	* through unmount. Implies an intriem communication break down
>> +	* and not necessarily a candidate for the device replace. And
>> +	* device might be online after user intervention or after
>> +	* block transport layer error recovery.
>> +	*/
>> +	int offline;
>>   	int can_discard;
>>   	int is_tgtdev_for_dev_replace;
>>   	blk_status_t last_flush_error;
>> @@ -544,5 +557,5 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>   bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
>>   void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
>>   				 u8 *uuid);
>> -
>> +void btrfs_mark_device_failed(struct btrfs_device *dev);
>>   #endif
>> -- 
>> 2.7.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
