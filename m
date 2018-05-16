Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeEPFGj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:06:39 -0400
Subject: Re: [PATCH] btrfs: update uuid_mutex and device_list_mutex comments
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180412022938.8257-1-anand.jain@oracle.com>
 <20180418095631.9977-1-anand.jain@oracle.com>
 <20180424154848.GK21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d6ba6955-18d7-d2ce-47eb-6a1ba8c0a661@oracle.com>
Date: Wed, 16 May 2018 13:09:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180424154848.GK21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/24/2018 11:48 PM, David Sterba wrote:
> On Wed, Apr 18, 2018 at 05:56:31PM +0800, Anand Jain wrote:
>> @@ -155,29 +155,26 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>    *
>>    * uuid_mutex (global lock)
>>    * ------------------------
>> - * protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
>> + * Protects the fs_uuids list that tracks all per-fs fs_devices, resulting from
>>    * the SCAN_DEV ioctl registration or from mount either implicitly (the first
>> - * device) or requested by the device= mount option
>> - *
>> - * the mutex can be very coarse and can cover long-running operations
>> - *
>> - * protects: updates to fs_devices counters like missing devices, rw devices,
>> - * seeding, structure cloning, openning/closing devices at mount/umount time
>> + * device) or requested by the device= mount option.
>>    *
>>    * global::fs_devs - add, remove, updates to the global list
>                ^^^^^^^
> 
> My typo, this should be fs_uuids.

right. Corrected in v2.

> 
>>    * fs_devices::device_list_mutex (per-fs, with RCU)
>>    * ------------------------------------------------
>> - * protects updates to fs_devices::devices, ie. adding and deleting
>> + * Protects updates to fs_devices::devices, ie. adding and deleting, and its
>> + * counters like missing devices, rw devices, seeding, structure cloning,
>> + * openning/closing devices at mount/umount time.
>>    *
>> - * simple list traversal with read-only actions can be done with RCU protection
>> + * Simple list traversal with read-only actions can be done with RCU protection.
>>    *
>> - * may be used to exclude some operations from running concurrently without any
>> - * modifications to the list (see write_all_supers)
>> + * May be used to exclude some operations from running concurrently without any
>> + * modifications to the list (see write_all_supers).
> 
> The uuid_mutex usage is a bit muddy, so far I think that most uses are
> not necessary so this is in line with this patchset. In some cases we
> might need to add the device_list_mutex once uuid mutex is gone.

> The clear usage of the uuid_mutex is when a new fs_devices is added to
> the global fs_uuids, to prevent concurrent access by device scan and
> mount.

  Yes. I have part#2 of uuid_mutex which will cleanup this part.
  I got diverged into something else before I could send. Will send soon.
  Sorry for the delay.

> Another one is the seed fs manipulation, that on the higher level
> works on the linked fs_devices. And the last one is the device renames
> that happen after a device appears under a different name.

  Sprout doesn't need uuid_mutex, it would need device_list_mutex of
  the respective seed fs_devices. I am planning this in part#3.
  As of now its ok to continue to use uuid_mutex.

> So far I haven't noticed any problems during tests of for-next with this
> patchset, so I guess we'd have to try harder to trigger the potential
> races.

> Thre's no device add/delete/replace/scan stress tests.

   stress tests - to exerciser concurrency - right.

> The
> seeding is not very well covered by tests, so I'll keep the branch in
> for-next, but more tests are welcome.

  Let me find time to add in part#3 as above.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
