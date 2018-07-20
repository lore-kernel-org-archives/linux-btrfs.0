Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34302 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725139AbeGTH5G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 03:57:06 -0400
Subject: Re: [PATCH 3/7] btrfs: do device clone using the
 btrfs_scan_one_device
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-4-anand.jain@oracle.com>
 <20180719123100.GK26141@twin.jikos.cz>
 <30f7fb70-ace0-0fd4-a7fe-f4fa7282b45b@oracle.com>
Message-ID: <7bce736e-2e2b-bd9a-c8c9-686b1b5e0c43@oracle.com>
Date: Fri, 20 Jul 2018 15:13:39 +0800
MIME-Version: 1.0
In-Reply-To: <30f7fb70-ace0-0fd4-a7fe-f4fa7282b45b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/20/2018 02:35 PM, Anand Jain wrote:
> 
> 
> On 07/19/2018 08:31 PM, David Sterba wrote:
>> On Mon, Jul 16, 2018 at 10:58:08PM +0800, Anand Jain wrote:
>>> When we add a device to the RO mounted seed device, it becomes a
>>> RW sprout FS. The following steps are used to hold the seed and
>>> sprout fs_devices.
>>>   (first two steps are not mandatory for the sprouting, they are there
>>>    to ensure the seed device remains in the scanned state)
>>>    . Clone the (mounted) fs_devices, lets call it as old_devices
>>>    . Now add old_devices to fs_uuids (yeah, there is duplicate fsid 
>>> in the
>>>      list, as we are under uuid_mutex so its fine).
>>>    . Alloc a new fs_devices, lets call it as seed_devices
>>>    . Copy fs_devices into the seed_devices
>>>    . Move fs_devices::devices into seed_devices::devices
>>>    . Bring seed_devices to under fs_devices::seed
>>>      (fs_devices->seed = seed_devices)
>>>    . Assign a new FSID to the fs_devices and add the new writable device
>>>      to the fs_devices.
>>
>>> This patch makes the following changes..
>>> As we clone fs_devices to make sure the device remains scanned after the
>>> sprouting. So use the btrfs_scan_one_device() code instead. And do it
>>> at the end of the sprouting.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/volumes.c | 21 ++++++++++++---------
>>>   1 file changed, 12 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 8450bcfed4cb..c6f3f0dfbabe 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -2179,7 +2179,7 @@ int btrfs_find_device_by_devspec(struct 
>>> btrfs_fs_info *fs_info, u64 devid,
>>>   static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
>>>   {
>>>       struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>> -    struct btrfs_fs_devices *old_devices;
>>> +    struct btrfs_fs_devices *old_fs_devices;
>>>       struct btrfs_fs_devices *seed_devices;
>>>       struct btrfs_super_block *disk_super = fs_info->super_copy;
>>>       struct btrfs_device *device;
>>> @@ -2193,14 +2193,6 @@ static int btrfs_prepare_sprout(struct 
>>> btrfs_fs_info *fs_info)
>>>       if (IS_ERR(seed_devices))
>>>           return PTR_ERR(seed_devices);
>>> -    old_devices = clone_fs_devices(fs_devices);
>>> -    if (IS_ERR(old_devices)) {
>>> -        kfree(seed_devices);
>>> -        return PTR_ERR(old_devices);
>>> -    }
>>> -
>>> -    list_add(&old_devices->fs_list, &fs_uuids);
>>> -
>>>       memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
>>>       seed_devices->opened = 1;
>>>       INIT_LIST_HEAD(&seed_devices->devices);
>>> @@ -2233,6 +2225,17 @@ static int btrfs_prepare_sprout(struct 
>>> btrfs_fs_info *fs_info)
>>>                 ~BTRFS_SUPER_FLAG_SEEDING;
>>>       btrfs_set_super_flags(disk_super, super_flags);
>>> +    /*
>>> +     * As the above code hijacked the original seed fs_devices, now
>>> +     * create a new one for the original seed FSID.
>>> +     */
>>> +    list_for_each_entry(device, &fs_devices->seed->devices, dev_list) {
>>> +        if (!device->name)
>>> +            continue;
>>> +        btrfs_scan_one_device(device->name->str, FMODE_READ,
>>> +                      fs_info->bdev_holder, &old_fs_devices);
>>
>> So this is clone_fs_devices vs btrfs_scan_one_device approach. The clone
>> only copies the devices from memory, while scan reads the superblock
>> from the block device.
> 
>   Right.
> 
>> The changelog describes how the new fsdevices is built but does not
>> explain why the new method is better than the current one. The end
>> result is possibly the same and the current code does the necessary work
>> to add the new fsdevices, while scanning will add the new fsid.
>>
>> The rest of code adding the new device in device_list_add and inside the
>> loop in clone_fs_devices is equivalent.
> 
>   Its just a code consolidate patch.

  I am dropping this patch in the next upcoming patchset revision, as
  there isn't considerable benefit in using the btrfs_scan_one_device()
  VS clone_fs_devices().

Thanks, Anand

> Thanks, Anand
> 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
