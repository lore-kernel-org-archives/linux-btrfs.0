Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47414 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753001AbeDQOaw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 10:30:52 -0400
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180417014719.3799-1-wqu@suse.com>
 <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
 <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <11f21c80-6089-8c26-3a36-92d5d9c2b2b0@oracle.com>
Date: Tue, 17 Apr 2018 22:32:51 +0800
MIME-Version: 1.0
In-Reply-To: <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/17/2018 05:58 PM, Qu Wenruo wrote:
> 
> 
> On 2018年04月17日 17:05, Anand Jain wrote:
>>
>>> v3:
>>>     Update commit message to show the corruption in details.
>>>     Modify the kernel error message to show corruption is detected before
>>>     transaction commitment.
>>   Nice. Thanks. more below.
>>
>>> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device
>>> *device,
>>>              btrfs_set_super_bytenr(sb, bytenr);
>>>    +        /* check the validation of the primary sb before writing */
>>> +        if (i == 0) {
>>> +            ret = btrfs_check_super_valid(device->fs_info, sb);
>>> +            if (ret) {
>>> +                btrfs_err(device->fs_info,
>>> +"superblock corruption detected before transaction commitment for
>>> device %llu",
>>> +                      device->devid);
>>> +                return -EUCLEAN;
>>> +            }
>>
>>   Why not move this entire check further below, after we have the ready
>>   crc and use btrfs_check_super_csum(), instead of
>>   btrfs_check_super_valid()? so that we verify only what is known to be
>>   corrupted that is ..
> 
> The problem is, we don't know the cause yet, so we must check the whole
> superblock.
> 
> For example, if the corruption is caused by some wild pointer of other
> kernel module, and we're just unlucky that one day it corrupts nodesize,
> then we can't detect it if we only check certain members.

Right I notice that.

But without btrfs_check_super_csum(), it leaves out checking one of the
member (csum_type) which is know to be corrupted at the two instances,
so it can also include btrfs_check_super_csum().

There were two cases, both of them corrupted the same offset, its not
just a coincidence that both of these reported corrupted the same
offset.

Also the incompatible features flags (169) are still valid in both the
cases. It looks as if we wrote u32 to a u64. I notice that we provide
the options to write the incompatible flags through mount option, sysfs
and ioctl.


>> btrfs_super_block {
>> ::
>>          __le64 incompat_flags;
>>          __le16 csum_type;
>> ::
>> }
>>
>>   And also can you dump contents of incompat_flags and csum_type at both
>>     fs_info->super_copy
>>   and
>>     fs_info->super_for_commit
> 
> Not really needed, as when corruption happens, it's super_copy
> corrupted, not something went wrong after we called memcpy()

As shown below, we aren't memcpy()-ing in the btrfs_sync_log() thread,
did you check if btrfs_sync_log() can not be the last person to write
at umount?

Thanks, Anand

> Thanks,
> Qu
> 
>>
>>   Because at each commit transaction we
>>
>> btrfs_commit_transaction()
>> {
>>    ::
>>          memcpy(fs_info->super_for_commit, fs_info->super_copy,
>>                 sizeof(*fs_info->super_copy));
>>    ::
>>          ret = write_all_supers(fs_info, 0);
>>
>> }
>>
>>   And also the sync log can write the
>>
>> btrfs_sync_log()
>> {
>> ::
>>          ret = write_all_supers(fs_info, 1);
>>
>>
>>   Finally locks between these two threads needs a review as well.
>>
>> Thanks, Anand
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
