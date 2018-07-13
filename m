Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727261AbeGMLbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 07:31:22 -0400
Subject: Re: [PATCH 2/3] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180710182241.23754-1-anand.jain@oracle.com>
 <20180710182241.23754-2-anand.jain@oracle.com>
 <0547e58c-3142-9338-474e-780a8eb0eef6@suse.com>
 <dc69c139-dcf6-6ed7-7453-ef8f64f78b68@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2ce4bc42-02b8-48b8-aeec-cb60bb39bff5@suse.com>
Date: Fri, 13 Jul 2018 14:17:06 +0300
MIME-Version: 1.0
In-Reply-To: <dc69c139-dcf6-6ed7-7453-ef8f64f78b68@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.07.2018 14:17, Anand Jain wrote:
> 
> 
> On 07/12/2018 03:31 PM, Nikolay Borisov wrote:
>>
>>
>> On 10.07.2018 21:22, Anand Jain wrote:
>>> When the replace is running the fs_devices::num_devices also includes
>>> the replace device, however in some operations like device delete and
>>> balance it needs the actual num_devices without the repalce devices, so
>>> now the function btrfs_num_devices() just provides that.
> 
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/volumes.c | 31 +++++++++++++++++--------------
>>>   1 file changed, 17 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index ce6faeb8bcf8..59a6d8f42c98 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -1931,6 +1931,20 @@ void btrfs_assign_next_active_device(struct
>>> btrfs_fs_info *fs_info,
>>>           fs_info->fs_devices->latest_bdev = next_device->bdev;
>>>   }
>>>   
>>
>> Put a comment above the function saying it returns the number of devices
>> minus the replace device (in case replace is working) otherwise one have
>> to go and 'git blame' it
> 
> good idea will rename it to btrfs_num_devices_minus_replace(), (will
> wait to see if there is any better suggested).

Unfortunately I don't have a better name yet but
num_devices_minus_replace is way too verbose so don't use that...

> 
> Thanks, Anand
> 
> 
> 
>>> +static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>>> +{
>>> +    u64 num_devices = fs_info->fs_devices->num_devices;
>>> +
>>> +    btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>> +    if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>>> +        WARN_ON(num_devices < 1);
>>> +        num_devices--;
>>> +    }
>>> +    btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>> +
>>> +    return num_devices;
>>> +}
>>> +
>>>   int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char
>>> *device_path,
>>>           u64 devid)
>>>   {
>>> @@ -1944,13 +1958,7 @@ int btrfs_rm_device(struct btrfs_fs_info
>>> *fs_info, const char *device_path,
>>>         mutex_lock(&uuid_mutex);
>>>   -    num_devices = fs_devices->num_devices;
>>> -    btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>> -    if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>>> -        WARN_ON(num_devices < 1);
>>> -        num_devices--;
>>> -    }
>>> -    btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>> +    num_devices = btrfs_num_devices(fs_info);
>>>         ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
>>>       if (ret)
>>> @@ -3810,13 +3818,8 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>>           }
>>>       }
>>>   -    num_devices = fs_info->fs_devices->num_devices;
>>> -    btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>> -    if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>>> -        WARN_ON(num_devices < 1);
>>> -        num_devices--;
>>> -    }
>>> -    btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>> +    num_devices = btrfs_num_devices(fs_info);
>>> +
>>>       allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
>>>       if (num_devices > 1)
>>>           allowed |= (BTRFS_BLOCK_GROUP_RAID0 |
>>> BTRFS_BLOCK_GROUP_RAID1);
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
