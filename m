Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54107 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdLHMo3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 07:44:29 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
 <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
 <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
 <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0565fd10-2c6d-5b11-105d-b5f5e12a7de3@oracle.com>
Date: Fri, 8 Dec 2017 20:41:51 +0800
MIME-Version: 1.0
In-Reply-To: <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2017 08:02 PM, Qu Wenruo wrote:
> 
> 
> On 2017年12月08日 19:48, Anand Jain wrote:
>>
>>
>> On 12/08/2017 07:01 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年12月08日 18:39, Anand Jain wrote:
>>>>
>>>>
>>>> On 12/08/2017 04:17 PM, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2017年12月08日 15:57, Anand Jain wrote:
>>>>>> -EXPERIMENTAL-
>>>>>> As of now when primary SB fails we won't self heal and would fail
>>>>>> mount,
>>>>>> this is an experimental patch which thinks why not go and read backup
>>>>>> copy.
>>>>>
>>>>> Just curious about in which real world case that backup super block can
>>>>> help.
>>>>> At least from what I see in mail list, only few cases where backup
>>>>> super
>>>>> helps.
>>>>
>>>>    Theoretical design helps. I ended up in this situation though. And
>>>>    ext4 has -o sb flag to manage this part. When we can expect EIO on
>>>>    any part of the disk block why not on the LBA which contains primary
>>>>    SB. And should we fail the mount for that reason ? No.
>>>
>>> And how do you ensure it's a btrfs?
>>
>>   Hmm. You mean outside of btrfs ? I did experiment with wipe and then
>>   using /etc/fstab to mount, and it did lead to btrfs, is that your
>>   concern that it shouldn't have been. That looked surprising to me as
>>   well, but then problem points at wipefs instead.
> 
> It's closer, but still doesn't reach the point.
> It can be a mkfs, other than wipefs.
> 
> It's can be another case like:
> 
> One user used btrfs for a while
> But bugs made him/her unhappy, and he/she turned to use xfs (whatever
> the fs is) instead.
> 
> While he/she forgot to change its fstab, and rebooted the system.
> 
> And suddenly, it's btrfs again!
> What a surprise.
> 

  I have worked quite a lot on defining the problem statements before
  btrfs. Here the user has to be blamed to have forgotten to update
  the fstab. I don't understand why should we workaround in btrfs for
  the reason that user may miss to update fstab. We don't design
  a stuff that like that, we design for the purpose, here backup SB
  is for the purpose that we all know, if we don't use backup SB, then
  its an incomplete design.

>>
>>>
>>>>
>>>>> Despite that self super heal seems good, although I agree with
>>>>> David, we
>>>>> need a weaker but necessary check (magic and fsid from primary super?)
>>>>> to ensure it's a valid btrfs before we use the backup supers.
>>>>
>>>>    Of course, we already have btrfs_check_super_valid() to verify the SB,
>>>>    I don't understand why - how do we verify the SB should be the
>>>> point of
>>>>    concern here, at all.
>>>
>>> The point here is, to distinguish an old and invalid btrfs (some other
>>> valid fs mkfs beyond the old fs) from a valid btrfs with corrupted
>>> primary fs.
>>
>>   Ok. When you check all the SBs you would pick the one which has passed
>>   btrfs_check_super_valid() and has highest generation. Did I ans your
>>   concern ? If a SB does not pass btrfs_check_super_valid() its not a
>>   valid btrfs SB at all.
> 
> No, not really.
> 
> What if the first SB is a XFS one or even a fs you didn't ever hear?
> 
> Skip it and use the 2nd one?
> This filesystem is not even btrfs anymore.

  There is no problem is user does the correct thing that is to
  update the fstab. OR using a complete mount command. If user
  using -t btrfs OR unupdated btrfs then it indicates his intentions.

Thanks, Anand

> Thanks,
> Qu
> 
>>
>>
>>> This the main concern here.
>>> The difference between recovery and recognizing a bad btrfs is quite
>>> important.
>>
>>   btrfs_check_super_valid() is already doing that right ? The point here
>>   is, should we use the backup SB when btrfs_check_super_valid() fails on
>>   primary SB.
>>
>> Thanks, Anand
>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Thanks, Anand
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>>>
>>>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>>> ---
>>>>>>     fs/btrfs/disk-io.c |  8 +++++++-
>>>>>>     fs/btrfs/volumes.c | 10 +++++++---
>>>>>>     2 files changed, 14 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>>> index 9b20c1f3563b..a791b8dfe8a8 100644
>>>>>> --- a/fs/btrfs/disk-io.c
>>>>>> +++ b/fs/btrfs/disk-io.c
>>>>>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct
>>>>>> block_device *bdev)
>>>>>>          * So, we need to add a special mount option to scan for
>>>>>>          * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>>>>>>          */
>>>>>> -    for (i = 0; i < 1; i++) {
>>>>>> +    for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>>>>>             ret = btrfs_read_dev_one_super(bdev, i, &bh);
>>>>>>             if (ret)
>>>>>>                 continue;
>>>>>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct
>>>>>> btrfs_fs_info *fs_info)
>>>>>>             ret = -EINVAL;
>>>>>>         }
>>>>>>     +#if 0
>>>>>> +    /*
>>>>>> +     * Need a way to check for any copy of SB, as its not a
>>>>>> +     * strong check, just ignore this for now.
>>>>>> +     */
>>>>>>         if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
>>>>>>             btrfs_err(fs_info, "super offset mismatch %llu != %u",
>>>>>>                   btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>>>>>             ret = -EINVAL;
>>>>>>         }
>>>>>> +#endif
>>>>>>           /*
>>>>>>          * Obvious sys_chunk_array corruptions, it must hold at least
>>>>>> one key
>>>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>>>> index 9fa2539a8493..f368db94d62b 100644
>>>>>> --- a/fs/btrfs/volumes.c
>>>>>> +++ b/fs/btrfs/volumes.c
>>>>>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,
>>>>>> fmode_t flags, void *holder,
>>>>>>     {
>>>>>>         struct btrfs_super_block *disk_super;
>>>>>>         struct block_device *bdev;
>>>>>> -    struct page *page;
>>>>>> +    struct buffer_head *sb_bh;
>>>>>>         int ret = -EINVAL;
>>>>>>         u64 devid;
>>>>>>         u64 transid;
>>>>>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path,
>>>>>> fmode_t flags, void *holder,
>>>>>>             goto error;
>>>>>>         }
>>>>>>     -    if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
>>>>>> +    sb_bh = btrfs_read_dev_super(bdev);
>>>>>> +    if (IS_ERR(sb_bh)) {
>>>>>> +        ret = PTR_ERR(sb_bh);
>>>>>>             goto error_bdev_put;
>>>>>> +    }
>>>>>> +    disk_super = (struct btrfs_super_block *) sb_bh->b_data;
>>>>>>           devid = btrfs_stack_device_id(&disk_super->dev_item);
>>>>>>         transid = btrfs_super_generation(disk_super);
>>>>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>>>>>> fmode_t flags, void *holder,
>>>>>>         if (!ret && fs_devices_ret)
>>>>>>             (*fs_devices_ret)->total_devices = total_devices;
>>>>>>     -    btrfs_release_disk_super(page);
>>>>>> +    brelse(sb_bh);
>>>>>>       error_bdev_put:
>>>>>>         blkdev_put(bdev, flags);
>>>>>>
>>>>>
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
