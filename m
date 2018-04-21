Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52046 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbeDUFQI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 01:16:08 -0400
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
 <20180420151504.GR21272@twin.jikos.cz>
 <a5e4bc54-460e-7db7-ebaa-98e1d9aaee5e@oracle.com>
 <999a862f-a50b-9d21-94de-53463b6f3387@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <dff543e5-5c34-641c-87de-f9e3c8239fa8@oracle.com>
Date: Sat, 21 Apr 2018 13:18:09 +0800
MIME-Version: 1.0
In-Reply-To: <999a862f-a50b-9d21-94de-53463b6f3387@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/21/2018 10:43 AM, Qu Wenruo wrote:
> 
> 
> On 2018年04月21日 10:38, Anand Jain wrote:
>>
>>
>> On 04/20/2018 11:15 PM, David Sterba wrote:
>>> On Fri, Apr 20, 2018 at 10:32:03PM +0800, Anand Jain wrote:
>>>>
>>>>
>>>> On 04/19/2018 05:38 PM, Qu Wenruo wrote:
>>>>> Although we have already checked incompat flags manually before really
>>>>> mounting it, we could still enhance btrfs_check_super_valid() to check
>>>>> incompat flags for later write time super block validation check.
>>>>>
>>>>> This patch adds such incompat flags check for
>>>>> btrfs_check_super_valid(),
>>>>> currently it won't be triggered, but provides the basis for later write
>>>>> time check.
>>>>>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>>     fs/btrfs/disk-io.c | 13 +++++++++++++
>>>>>     1 file changed, 13 insertions(+)
>>>>>
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index 60caa68c3618..ec123158f051 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct
>>>>> btrfs_fs_info *fs_info)
>>>>>             ret = -EINVAL;
>>>>>         }
>>>>>     +    /*
>>>>> +     * Before calling btrfs_check_super_valid() we have already
>>>>> checked
>>>>> +     * incompat flags. So if we developr new incompat flags, it's
>>>>> must be
>>>>> +     * some corruption.
>>>>> +     */
>>>>> +    if (btrfs_super_incompat_flags(sb) &
>>>>> ~BTRFS_FEATURE_INCOMPAT_SUPP) {
>>>>> +        btrfs_err(fs_info,
>>>>> +        "corrupted incompat flags detected 0x%llx, supported 0x%llx",
>>>
>>>> 2707         features = btrfs_super_incompat_flags(disk_super) &
>>>> 2708                 ~BTRFS_FEATURE_INCOMPAT_SUPP;
>>>> 2709         if (features) {
>>>> 2710                 btrfs_err(fs_info,
>>>> 2711                     "cannot mount because of unsupported
>>>> optional features (%llx)",
>>>> 2712                     features);
>>>> 2713                 err = -EINVAL;
>>>> 2714                 goto fail_alloc;
>>>> 2715         }
>>>
>>> So there's a "user experience" change, now that you pointed out the
>>> other check.
>>
>>   Its a regression.
>>
>>> If a filesystem with incompat bits set will be mounted,
>>> this will say 'you have corrupted filesystem', which is not IMO what we
>>> want to tell.
>>>
>>> Tough the extended btrfs_check_super_valid could catch the corrupted
>>> incompat bits, what we need at mount time is wording from the 2nd
>>> message ("cannot mount unsuppported features").
>>>
>>> I think that there should be a separate function that does the
>>> pre-commit checks, calls btrfs_check_super_valid and also validates the
>>> incompat bit.
>>
>>   We can still print it as 'unsupported optional features', which would
>>   imply corruption in the non-mount context.
> 
> In that case such wording is not obvious enough to info it's super block
> corruption.

  If the device is already mounted. Then its a corruption.

Thanks, Anand

> So I still prefer current way of checking incompact flags and csum types
> manually at mount time before btrfs_validate_super().
> 
> David's idea of a separate function to do mount time check and gives
> better prompt is pretty good.
> Especially for incompat features, as incompat features will increase in
> the future and for older kernel info such feature as corruption is not
> acceptable.
> 
> But currently, there are only 2 members we need to check at mount time
> (csum_type and incompat features), and only one caller, current code
> looks good enough for its purpose.
> 
> Thanks,
> Qu
> 
>>
>> Thanks, Anand
>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
