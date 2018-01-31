Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeAaNh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 08:37:28 -0500
Subject: Re: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-3-anand.jain@oracle.com>
 <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
 <7a21d5f0-b7f0-9da6-22b6-b45976d6ab40@oracle.com>
 <7fdfcf9a-2bc5-7f1b-1417-3ccc95cdcf83@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <27eaef30-69ae-b5a6-2cd6-9035c61615e7@oracle.com>
Date: Wed, 31 Jan 2018 21:38:42 +0800
MIME-Version: 1.0
In-Reply-To: <7fdfcf9a-2bc5-7f1b-1417-3ccc95cdcf83@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/31/2018 05:54 PM, Nikolay Borisov wrote:
> 
> 
> On 31.01.2018 11:28, Anand Jain wrote:
>>
>>
>> On 01/31/2018 04:38 PM, Nikolay Borisov wrote:
>>>
>>>
>>> On 30.01.2018 08:30, Anand Jain wrote:
>>>> Adds the mount option:
>>>>     mount -o read_mirror_policy=<devid>
>>>>
>>>> To set the devid of the device which should be used for read. That
>>>> means all the normal reads will go to that particular device only.
>>>>
>>>> This also helps testing and gives a better control for the test
>>>> scripts including mount context reads.
>>>
>>> Some code comments below. OTOH, does such policy really make sense, what
>>> happens if the selected device fails, will the other mirror be retried?
>>
>>   Everything as usual, read_mirror_policy=devid just lets the user to
>>   specify his read optimized disk, so that we don't depend on the pid
>>   to pick a stripe mirrored disk, and instead we would pick as suggested
>>   by the user, and if that disk fails then we go back to the other mirror
>>   which may not be the read optimized disk as we have no other choice.
>>
>>> If the answer to the previous question is positive then why do we really
>>> care which device is going to be tried first?
>>
>>   It matters.
>>     - If you are reading from both disks alternatively, then it
>>       duplicates the LUN cache on the storage.
>>     - Some disks are read-optimized and using that for reading and going
>>       back to the other disk only when this disk fails provides a better
>>       overall read performance.
> 
> So usually this should be functionality handled by the raid/san
> controller I guess, > but given that btrfs is playing the role of a
> controller here at what point are we drawing the line of not
> implementing block-level functionality into the filesystem ?

  Don't worry this is not invading into the block layer. How
  can you even build this functionality in the block layer ?
  Block layer even won't know that disks are mirrored. RAID
  does or BTRFS in our case.

>> ::
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 39ba59832f38..478623e6e074 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -5270,6 +5270,16 @@ static int find_live_mirror(struct
>>>> btrfs_fs_info *fs_info,
>>>>            num = map->num_stripes;
>>>>          switch(fs_info->read_mirror_policy) {
>>>> +    case BTRFS_READ_MIRROR_BY_DEV:
>>>> +        optimal = first;
>>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>>> +                 &map->stripes[optimal].dev->dev_state))
>>>> +            break;
>>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>>> +                 &map->stripes[++optimal].dev->dev_state))
>>>> +            break;
>>>> +        optimal = first;
>>>
>>> you set optimal 2 times, the second one seems redundant.
>>
>>   No actually. When both the disks containing the stripe does not
>>   have the BTRFS_DEV_STATE_READ_MIRROR, then I would just want to
>>   use first found stripe.
> 
> Yes, and the fact that you've already set optimal = first right after
> BTRFS_READ_MIRROR_BY_DEV ensures that, no ? Why do you need to again set
> optimal right before the final break? What am I missing here?

   Ah. I think you are missing ++optimal in the 2nd if.

Thanks, Anand
