Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbeGLQv6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 12:51:58 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
Date: Fri, 13 Jul 2018 00:44:52 +0800
MIME-Version: 1.0
In-Reply-To: <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2018 08:59 PM, Qu Wenruo wrote:
> 
> 
> On 2018年07月12日 20:33, Anand Jain wrote:
>>
>>
>> On 07/12/2018 01:43 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年07月11日 15:50, Anand Jain wrote:
>>>>
>>>>
>>>> BTRFS Volume operations, Device Lists and Locks all in one page:
>>>>
>>>> Devices are managed in two contexts, the scan context and the mounted
>>>> context. In scan context the threads originate from the btrfs_control
>>>> ioctl and in the mounted context the threads originates from the mount
>>>> point ioctl.
>>>> Apart from these two context, there also can be two transient state
>>>> where device state are transitioning from the scan to the mount context
>>>> or from the mount to the scan context.
>>>>
>>>> Device List and Locks:-
>>>>
>>>>    Count: btrfs_fs_devices::num_devices
>>>>    List : btrfs_fs_devices::devices -> btrfs_devices::dev_list
>>>>    Lock : btrfs_fs_devices::device_list_mutex
>>>>
>>>>    Count: btrfs_fs_devices::rw_devices
>>>
>>> So btrfs_fs_devices::num_devices = btrfs_fs_devices::rw_devices + RO
>>> devices.
>>> How seed and ro devices are different in this case?
>>
>>   Given:
>>   btrfs_fs_devices::total_devices = btrfs_super_num_devices(disk_super);
>>
>>   Consider no missing devices, no replace target, no seeding. Then,
>>     btrfs_fs_devices::total_devices == btrfs_fs_devices::num_devices
>>
>>   And in case of seeding.
>>     btrfs_fs_devices::total_devices  == (btrfs_fs_devices::num_devices +
>>                                  btrfs_fs_devices::seed::total_devices
>>
>>     All devices in the list [1] are RW/Sprout
>>       [1] fs_info::btrfs_fs_devices::devices
>>     All devices in the list [2] are RO/Seed

  to avoid confusion I shall remove RO here
        All devices in the list [2] are Seed

>>       [2] fs_info::btrfs_fs_devices::seed::devices
>>
>>
>>   Thanks for asking will add this part to the doc.
> 
> Another question is, what if a device is RO but not seed?
> 
> E.g. loopback device set to RO.
> IMHO it won't be mounted RW for single device case, but not sure for
> multi device case.

  RO devices are different from the seed devices. If any one device is
  RO then FS is mounted in RO.

  And the btrfs_fs_devices::seed will still be NULL.

>>
>>>
>>>>    List : btrfs_fs_devices::alloc_list -> btrfs_devices::dev_alloc_list
>>>>    Lock : btrfs_fs_info::chunk_mutex
>>>
>>> At least the chunk_mutex is also shared with chunk allocator,
>>
>>   Right.
>>
>>> or we
>>> should have some mutex in btrfs_fs_devices other than fs_info.
>>> Right?
>>
>>   More locks? no. But some of the locks-and-flags are wrongly
>>   belong to fs_info instead it should have been in fs_devices.
>>   When the dust settles planning to propose to migrate them
>>   to fs_devices.
> 
> OK, migrating to fs_devices looks good to me then.
> 
>>
>>>>    Lock: set_bit btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>>>
>>>> FSID List and Lock:-
>>>>
>>>>    Count : None
>>>>    HEAD  : Global::fs_uuids -> btrfs_fs_devices::fs_list
>>>>    Lock  : Global::uuid_mutex
>>>>
>>>>
>>>> After the fs_devices is mounted, the btrfs_fs_devices::opened > 0.
>>>
>>> fs_devices::opended should be btrfs_fs_devices::num_devices if no device
>>> is missing and -1 or -2 for degraded case, right?
>>
>>   No. I think you are getting confused with
>>      btrfs_fs_devices::open_devices
>>
>>   btrfs_fs_devices::opened
>>    indicate how many times the volume is opened. And in reality it would
>>   stay at 1 always. (except for a short duration of time during
>>   subsequent subvol mount).
> 
> Thanks, this makes sense.
> 
>>
>>
>>>> In the scan context we have the following device operations..
>>>>
>>>> Device SCAN:-  which creates the btrfs_fs_devices and its corresponding
>>>> btrfs_device entries, also checks and frees the duplicate device
>>>> entries.
>>>> Lock: uuid_mutex
>>>>     SCAN
>>>>     if (found_duplicate && btrfs_fs_devices::opened == 0)
>>>>        Free_duplicate
>>>> Unlock: uuid_mutex
>>>>
>>>> Device READY:- check if the volume is ready. Also does an implicit scan
>>>> and duplicate device free as in Device SCAN.
>>>> Lock: uuid_mutex
>>>>     SCAN
>>>>     if (found_duplicate && btrfs_fs_devices::opened == 0)
>>>>        Free_duplicate
>>>>     Check READY
>>>> Unlock: uuid_mutex
>>>>
>>>> Device FORGET:- (planned) free a given or all unmounted devices and
>>>> empty fs_devices if any.
>>>> Lock: uuid_mutex
>>>>     if (found_duplicate && btrfs_fs_devices::opened == 0)
>>>>       Free duplicate
>>>> Unlock: uuid_mutex
>>>>
>>>> Device mount operation -> A Transient state leading to the mounted
>>>> context
>>>> Lock: uuid_mutex
>>>>    Find, SCAN, btrfs_fs_devices::opened++
>>>> Unlock: uuid_mutex
>>>>
>>>> Device umount operation -> A transient state leading to the unmounted
>>>> context or scan context
>>>> Lock: uuid_mutex
>>>>     btrfs_fs_devices::opened--
>>>> Unlock: uuid_mutex
>>>>
>>>>
>>>> In the mounted context we have the following device operations..
>>>>
>>>> Device Rename through SCAN:- This is a special case where the device
>>>> path gets renamed after its been mounted. (Ubuntu changes the boot path
>>>> during boot up so we need this feature). Currently, this is part of
>>>> Device SCAN as above. And we need the locks as below, because the
>>>> dynamic disappearing device might cleanup the btrfs_device::name
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>>      Rename
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Commit Transaction:- Write All supers.
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>>     Write all super of btrfs_devices::dev_list
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Device add:- Add a new device to the existing mounted volume.
>>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>      List_add btrfs_devices::dev_list
>>>>      List_add btrfs_devices::dev_alloc_list
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Device remove:- Remove a device from the mounted volume.
>>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>      List_del btrfs_devices::dev_list
>>>>      List_del btrfs_devices::dev_alloc_list
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Device Replace:- Replace a device.
>>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>      List_update btrfs_devices::dev_list
>>>
>>> Here we still just add a new device but not deleting the existing one
>>> until the replace is finished.
>>
>>   Right I did not elaborate that part. List_update: I meant add/delete
>>   accordingly.
>>
>>>>      List_update btrfs_devices::dev_alloc_list
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Sprouting:- Add a RW device to the mounted RO seed device, so to make
>>>> the mount point writable.
>>>> The following steps are used to hold the seed and sprout fs_devices.
>>>> (first two steps are not necessary for the sprouting, they are there to
>>>> ensure the seed device remains scanned, and it might change)
>>>> . Clone the (mounted) fs_devices, lets call it as old_devices
>>>> . Now add old_devices to fs_uuids (yeah, there is duplicate fsid in the
>>>> list but we change the other fsid before we release the uuid_mutex, so
>>>> its fine).
>>>>
>>>> . Alloc a new fs_devices, lets call it as seed_devices
>>>> . Copy fs_devices into the seed_devices
>>>> . Move fs_deviecs devices list into seed_devices
>>>> . Bring seed_devices to under fs_devices (fs_devices->seed =
>>>> seed_devices)
>>>> . Assign a new FSID to the fs_devices and add the new writable device to
>>>> the fs_devices.
>>>>
>>>> In the unmounted context the fs_devices::seed is always NULL.
>>>> We alloc the fs_devices::seed only at the time of mount and or at
>>>> sprouting. And free at the time of umount or if the seed device is
>>>> replaced or deleted.
>>>>
>>>> Locks: Sprouting:
>>>> Lock: uuid_mutex <-- because fsid rename and Device SCAN
>>>> Reuses Device Add code
>>>>
>>>> Locks: Splitting: (Delete OR Replace a seed device)
>>>> uuid_mutex is not required as fs_devices::seed which is local to
>>>> fs_devices is being altered.
>>>> Reuses Device replace code
>>>>
>>>>
>>>> Device resize:- Resize the given volume or device.
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>      Update
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>
>>>>
>>>> (Planned) Dynamic Device missing/reappearing:- A missing device might
>>>> reappear after its volume been mounted, we have the same btrfs_control
>>>> ioctl which does the scan of the reappearing device but in the mounted
>>>> context. In the contrary a device of a volume in a mounted context can
>>>> go missing as well, and still the volume will continue in the mounted
>>>> context.
>>>> Missing:
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>     List_del: btrfs_devices::dev_alloc_list
>>>>     Close_bdev
>>>>     btrfs_device::bdev == NULL
>>>>     btrfs_device::name = NULL
>>>>     set_bit BTRFS_DEV_STATE_MISSING
>>>>     set_bit BTRFS_VOL_STATE_DEGRADED
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> Reappearing:
>>>> Lock: btrfs_fs_devices::device_list_mutex
>>>> Lock: btrfs_fs_info::chunk_mutex
>>>>     Open_bdev
>>>>     btrfs_device::name = PATH
>>>>     clear_bit BTRFS_DEV_STATE_MISSING
>>>>     clear_bit BTRFS_VOL_STATE_DEGRADED
>>>>     List_add: btrfs_devices::dev_alloc_list
>>>>     set_bit BTRFS_VOL_STATE_RESILVERING
>>>>     kthread_run HEALTH_CHECK
>>>
>>> For this part, I'm planning to add scrub support for certain generation
>>> range, so just scrub for certain block groups which is newer than the
>>> last generation of the re-appeared device should be enough.
>>>
>>> However I'm wondering if it's possible to reuse btrfS_balance_args, as
>>> we really have a lot of similarity when specifying block groups to
>>> relocate/scrub.
>>
>>   What you proposed sounds interesting. But how about failed writes
>>   at some generation number and not necessarily at the last generation?
> 
> In this case, it depends on when and how we mark the device resilvering.
> If we record the generation of write error happens, then just initial a
> scrub for generation greater than that generation.

  If we record all the degraded transactions then yes. Not just the last
  failed transaction.

> In the list, some guys mentioned that for LVM/mdraid they will record
> the generation when some device(s) get write error or missing, and do
> self cure.
 >
>>
>>   I have been scratching on fix for this [3] for some time now. Thanks
>>   for the participation. In my understanding we are missing across-tree
>>   parent transid verification at the lowest possible granular OR
> 
> Maybe the newly added first_key and level check could help detect such
> mismatch?
> 
>>   other approach is to modify Liubo approach to provide a list of
>>   degraded chunks but without a journal disk.
> 
> Currently, DEV_ITEM::generation is seldom used. (only for seed sprout case)
> Maybe we could reuse that member to record the last successful written
> transaction to that device and do above purposed LVM/mdraid style self cure?

  Record of just the last successful transaction won't help. OR its an
  overkill to fix a write hole.

  Transactions: 10 11 [12] [13] [14] <---- write hole ----> [19] [20]
  In the above example
   disk disappeared at transaction 11 and when it reappeared at
   the transaction 19, there were new writes as well as the resilver
   writes, so we were able to write 12 13 14 and 19 20 and then
   the disk disappears again leaving a write hole. Now next time when
   disk reappears the last transaction indicates 20 on both-disks
   but leaving a write hole in one of disk. But if you are planning to
   record and start at transaction [14] then its an overkill because
   transaction [19 and [20] are already in the disk.

Thanks, Anand


> Thanks,
> Qu
> 
>>     [3] https://patchwork.kernel.org/patch/10403311/
>>
>>   Further, as we do a self adapting chunk allocation in RAID1, it needs
>>   balance-convert to fix. IMO at some point we have to provide degraded
>>   raid1 chunk allocation and also modify the scrub to be chunk granular.
>>
>> Thanks, Anand
>>
>>> Any idea on this?
>>>
>>> Thanks,
>>> Qu
>>>
>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>
>>>> -----------------------------------------------------------------------
>>>>
>>>> Thanks, Anand
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
