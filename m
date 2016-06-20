Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33714 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbcFTIdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 04:33:07 -0400
Subject: Re: [PATCH 2/2] btrfs: wait for bdev put
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
References: <1e7bc117-aaa3-c77f-b933-cd0c37b5ce68@oracle.com>
 <1465901726-15490-1-git-send-email-anand.jain@oracle.com>
 <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <pan$54f91$8f404ca0$263fcbd1$6151141c@applied-asynchrony.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <67fa6380-1f92-ce6a-b8cd-6f5903f48837@oracle.com>
Date: Mon, 20 Jun 2016 16:33:52 +0800
MIME-Version: 1.0
In-Reply-To: <pan$54f91$8f404ca0$263fcbd1$6151141c@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/19/2016 12:34 AM, Holger Hoffstätte wrote:
> On Tue, 14 Jun 2016 18:55:26 +0800, Anand Jain wrote:
>
>> Further to the previous commit
>>  bc178622d40d87e75abc131007342429c9b03351
>>  btrfs: use rcu_barrier() to wait for bdev puts at unmount
>>
>> Since free_device() spinoff __free_device() the rcu_barrier() for
>>       call_rcu(&device->rcu, free_device);
>> didn't help.
>>
>> This patch reverts changes by
>>  bc178622d40d87e75abc131007342429c9b03351
>> and implement a method to wait on the __free_device() by using
>> a new bdev_closing member in struct btrfs_device.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> [rework: bc178622d40d87e75abc131007342429c9b03351]
>> ---
>>  fs/btrfs/volumes.c | 44 ++++++++++++++++++++++++++++++++++++++------
>>  fs/btrfs/volumes.h |  1 +
>>  2 files changed, 39 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index a4e8d48acd4b..404ce1daebb1 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/raid/pq.h>
>>  #include <linux/semaphore.h>
>>  #include <linux/uuid.h>
>> +#include <linux/delay.h>
>>  #include <asm/div64.h>
>>  #include "ctree.h"
>>  #include "extent_map.h"
>> @@ -254,6 +255,17 @@ static struct btrfs_device *__alloc_device(void)
>>  	return dev;
>>  }
>>
>> +static int is_device_closing(struct list_head *head)
>> +{
>> +	struct btrfs_device *dev;
>> +
>> +	list_for_each_entry(dev, head, dev_list) {
>> +		if (dev->bdev_closing)
>> +			return 1;
>> +	}
>> +	return 0;
>> +}
>> +
>>  static noinline struct btrfs_device *__find_device(struct list_head *head,
>>  						   u64 devid, u8 *uuid)
>>  {
>> @@ -832,12 +844,22 @@ again:
>>  static void __free_device(struct work_struct *work)
>>  {
>>  	struct btrfs_device *device;
>> +	struct btrfs_device *new_device_addr;
>>
>>  	device = container_of(work, struct btrfs_device, rcu_work);
>>
>>  	if (device->bdev)
>>  		blkdev_put(device->bdev, device->mode);
>>
>> +	/*
>> +	 * If we are coming here from btrfs_close_one_device()
>> +	 * then it allocates a new device structure for the same
>> +	 * devid, so find device again with the devid
>> +	 */
>> +	new_device_addr = __find_device(&device->fs_devices->devices,
>> +						device->devid, NULL);
>> +
>> +	new_device_addr->bdev_closing = 0;
>>  	rcu_string_free(device->name);
>>  	kfree(device);
>>  }
>> @@ -884,6 +906,12 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>>  	list_replace_rcu(&device->dev_list, &new_device->dev_list);
>>  	new_device->fs_devices = device->fs_devices;
>>
>> +	/*
>> +	 * So to wait for kworkers to finish all blkdev_puts,
>> +	 * so device is really free when umount is done.
>> +	 */
>> +	new_device->bdev_closing = 1;
>> +
>>  	call_rcu(&device->rcu, free_device);
>>  }
>>
>> @@ -912,6 +940,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  {
>>  	struct btrfs_fs_devices *seed_devices = NULL;
>>  	int ret;
>> +	int retry_cnt = 5;
>>
>>  	mutex_lock(&uuid_mutex);
>>  	ret = __btrfs_close_devices(fs_devices);
>> @@ -927,12 +956,15 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  		__btrfs_close_devices(fs_devices);
>>  		free_fs_devices(fs_devices);
>>  	}
>> -	/*
>> -	 * Wait for rcu kworkers under __btrfs_close_devices
>> -	 * to finish all blkdev_puts so device is really
>> -	 * free when umount is done.
>> -	 */
>> -	rcu_barrier();
>> +
>> +	while (is_device_closing(&fs_devices->devices) &&
>> +						--retry_cnt) {
>> +		mdelay(1000); //1 sec
>> +	}
>> +
>> +	if (!(retry_cnt > 0))
>> +		printk(KERN_WARNING "BTRFS: %pU bdev_put didn't complete, giving up\n",
>> +			fs_devices->fsid);
>>  	return ret;
>>  }
>>
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 0ac90f8d85bd..945e49f5e17d 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -150,6 +150,7 @@ struct btrfs_device {
>>  	/* Counter to record the change of device stats */
>>  	atomic_t dev_stats_ccnt;
>>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
>> +	int bdev_closing;
>>  };
>>
>>  /*
>> --
>> 2.7.0
>
> I gave this a try and somehow it seems to make unmounting worse:
> it now always takes ~5s (max retry time) and I see the warning every
> time. Without the patch unmounting a single volume (disk) is much
> faster (1-2s), without problems.

  Thanks Holger, for testing.
  It depends on long the blkdev_put() will take, originally unmount
  thread didn't wait for it to complete, so it was faster, but had
  other problem as explained.

Thanks, Anand

> Any ideas?


> cheers,
> Holger


