Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31156 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934336AbdKQHq2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 02:46:28 -0500
Subject: Re: [PATCH] btrfs: handle dynamically reappearing missing device
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <4130bd50-b1f3-2d8b-c762-be0b9dbb87bd@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <331f782d-b5e6-f5f0-d36f-701e20b3a3f7@oracle.com>
Date: Fri, 17 Nov 2017 15:46:33 +0800
MIME-Version: 1.0
In-Reply-To: <4130bd50-b1f3-2d8b-c762-be0b9dbb87bd@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/17/2017 03:08 AM, Nikolay Borisov wrote:
> 
> 
> On 12.11.2017 12:56, Anand Jain wrote:
>> If the device is not present at the time of (-o degrade) mount
>> the mount context will create a dummy missing struct btrfs_device.
>> Later this device may reappear after the FS is mounted. So this
>> patch handles that case by going through the open_device steps
>> which this device missed and finally adds to the device alloc list.
>>
>> So now with this patch, to bring back the missing device user can run,
>>
>>     btrfs dev scan <path-of-missing-device>
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> This patch needs:
>>   [PATCH 0/4]  factor __btrfs_open_devices()
>>
>>   fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index d24e966ee29f..e7dd996831f2 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -769,8 +769,47 @@ static noinline int device_list_add(const char *path,
>>   		rcu_string_free(device->name);
>>   		rcu_assign_pointer(device->name, name);
>>   		if (device->missing) {
>> -			fs_devices->missing_devices--;
>> -			device->missing = 0;
>> +			int ret;
>> +			struct btrfs_fs_info *fs_info = fs_devices->fs_info;
>> +			fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
>> +
>> +			if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
>> +				fmode &= ~FMODE_WRITE;
>> +
>> +			/*
>> +			 * Missing can be set only when FS is mounted.
>> +			 * So here its always fs_devices->opened > 0 and most
>> +			 * of the struct device members are already updated by
>> +			 * the mount process even if this device was missing, so
>> +			 * now follow the normal open device procedure for this
>> +			 * device. The scrub will take care of filling the
>> +			 * missing stripes for raid56 and balance for raid1 and
>> +			 * raid10.
>> +			 */
>> +			ASSERT(fs_devices->opened);
>> +			mutex_lock(&fs_devices->device_list_mutex);
>> +			mutex_lock(&fs_info->chunk_mutex);
>> +			ret = btrfs_open_one_device(fs_devices, device, fmode,
>> +							fs_info->bdev_holder);
>> +			if (!ret) {
>> +				fs_devices->missing_devices--;
>> +				device->missing = 0;
>> +				btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
>> +				btrfs_warn(fs_info,
>> +					"BTRFS: device %s devid %llu uuid %pU joined\n",
>> +					path, devid, device->uuid);
>> +			}
>> +
>> +			if (device->writeable &&
>> +					!device->is_tgtdev_for_dev_replace) {
>> +				fs_devices->total_rw_bytes += device->total_bytes;
>> +				atomic64_add(device->total_bytes -
>> +						device->bytes_used,
>> +						&fs_info->free_chunk_space);
>> +			}
>> +			device->in_fs_metadata = 1;
>> +			mutex_unlock(&fs_devices->fs_info->chunk_mutex);
>> +			mutex_unlock(&fs_devices->device_list_mutex);
> 
> nit: You did add the fs_info local var, so for consistency's sake use that

  Thanks. Will fix it.

-Anand

>>   		}
>>   	}
>>   
>>
