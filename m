Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59488 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbbIRCGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 22:06:38 -0400
Subject: Re: [PATCH 2/2] btrfs: Remove unneeded missing device number check
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        <linux-btrfs@vger.kernel.org>
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com>
 <55FA8B31.9080604@oracle.com> <55FA8F8B.6060903@gmx.com>
 <55FB6D31.9030504@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55FB71A8.3000004@cn.fujitsu.com>
Date: Fri, 18 Sep 2015 10:06:32 +0800
MIME-Version: 1.0
In-Reply-To: <55FB6D31.9030504@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/09/18 09:47 +0800:
>
>
> On 09/17/2015 06:01 PM, Qu Wenruo wrote:
>> Thanks for pointing this out.
>
>
>> Although previous patch is small enough, but for remount case, we need
>> to iterate all the existing chunk cache.
>
>   yes indeed.
>
>   thinking hard on this - is there any test-case that these two patches
> are solving, which the original patch [1] didn't solve ?

Yep, your patch is OK to fix single chunk on safe disk case.
But IMHO, it's a little aggressive and not safe as old codes.

For example, if one use single metadata for 2 disks, and each disk has 
one metadata chunk on it.

One device got missing later.

Then your patch will allow the fs to be mounted as rw, even some tree 
block can be in the missing device.
For RO case, it won't be too dangerous, but if we mounted it as RW, who 
knows what will happen.
(Normal tree COW thing should fail before real write, but I'm not sure 
about other RW operation like scrub/replace/balance and others)

And I think that's the original design concept behind the old missing 
device number check, and it's not a bad idea to follow it anyway.

For the patch size, I find a good idea to handle it, and should make the 
patch(set) size below 200 lines.

Further more, it's even possible to make btrfs change mount option to 
degraded for runtime device missing.

Thanks,
Qu
>
>   I tried to break both the approaches (this patch set and [1]) but I
> wasn't successful. sorry if I am missing something.
>
> Thanks, Anand
>
> [1] [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
>
>
>> So fix for remount will take a little more time.
>
>> Thanks for reviewing.
>> Qu
>>
>> 在 2015年09月17日 17:43, Anand Jain 写道:
>>>
>>>
>>> On 09/16/2015 11:43 AM, Qu Wenruo wrote:
>>>> As we do per-chunk missing device number check at read_one_chunk()
>>>> time,
>>>> it's not needed to do global missing device number check.
>>>>
>>>> Just remove it.
>>>
>>> However the missing device count, what we have during the remount is not
>>> fine grained per chunk.
>>> -----------
>>> btrfs_remount
>>> ::
>>>                   if (fs_info->fs_devices->missing_devices >
>>>                       fs_info->num_tolerated_disk_barrier_failures &&
>>>                      !(*flags & MS_RDONLY ||
>>>                          btrfs_test_opt(root, DEGRADED))) {
>>>                          btrfs_warn(fs_info,
>>>                                  "too many missing devices, writeable
>>> remount is not allowed");
>>>                          ret = -EACCES;
>>>                          goto restore;
>>>                  }
>>> ---------
>>>
>>> Thanks, Anand
>>>
>>>
>>>> Now btrfs can handle the following case:
>>>>   # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>>>>
>>>>   Data chunk will be located in sdb, so we should be safe to wipe sdc
>>>>   # wipefs -a /dev/sdc
>>>>
>>>>   # mount /dev/sdb /mnt/btrfs -o degraded
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>   fs/btrfs/disk-io.c | 8 --------
>>>>   1 file changed, 8 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 0b658d0..ac640ea 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -2947,14 +2947,6 @@ retry_root_backup:
>>>>       }
>>>>       fs_info->num_tolerated_disk_barrier_failures =
>>>>           btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>>>> -    if (fs_info->fs_devices->missing_devices >
>>>> -         fs_info->num_tolerated_disk_barrier_failures &&
>>>> -        !(sb->s_flags & MS_RDONLY)) {
>>>> -        pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d),
>>>> writeable mount is not allowed\n",
>>>> -            fs_info->fs_devices->missing_devices,
>>>> -            fs_info->num_tolerated_disk_barrier_failures);
>>>> -        goto fail_sysfs;
>>>> -    }
>>>>
>>>>       fs_info->cleaner_kthread = kthread_run(cleaner_kthread,
>>>> tree_root,
>>>>                              "btrfs-cleaner");
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
