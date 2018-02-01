Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeBAF1I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 00:27:08 -0500
Subject: Re: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
To: Anand Jain <anand.jain@oracle.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-3-anand.jain@oracle.com>
 <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
 <7a21d5f0-b7f0-9da6-22b6-b45976d6ab40@oracle.com>
 <7fdfcf9a-2bc5-7f1b-1417-3ccc95cdcf83@suse.com>
 <27eaef30-69ae-b5a6-2cd6-9035c61615e7@oracle.com>
 <7eb73e78-f6ca-be5f-4505-a88d60172037@suse.com>
 <c0e67c67-324e-938a-b87c-3831c2604676@oracle.com>
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <d87d2cbb-0512-1c26-28c0-4e7733ec35bf@suse.de>
Date: Wed, 31 Jan 2018 22:26:53 -0700
MIME-Version: 1.0
In-Reply-To: <c0e67c67-324e-938a-b87c-3831c2604676@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/31/18 7:36 AM, Anand Jain wrote:
> 
> 
> On 01/31/2018 09:42 PM, Nikolay Borisov wrote:
> 
> 
>>>> So usually this should be functionality handled by the raid/san
>>>> controller I guess, > but given that btrfs is playing the role of a
>>>> controller here at what point are we drawing the line of not
>>>> implementing block-level functionality into the filesystem ?
>>>
>>>   Don't worry this is not invading into the block layer. How
>>>   can you even build this functionality in the block layer ?
>>>   Block layer even won't know that disks are mirrored. RAID
>>>   does or BTRFS in our case.
>>>
>>
>> By block layer I guess I meant the storage driver of a particular raid
>> card. Because what is currently happening is re-implementing
>> functionality that will generally sit in the driver. So my question was
>> more generic and high-level - at what point do we draw the line of
>> implementing feature that are generally implemented in hardware devices
>> (be it their drivers or firmware).
> 
>  Not all HW configs use RAID capable HBAs. A server connected to a SATA
>  JBOD using a SATA HBA without MD will relay on BTRFS to provide all the
>  features and capabilities that otherwise would have provided by such a
>  presumable HW config.

That does sort of sound like means implementing some portion of the
HBA features/capabilities in the filesystem.

To me it seems this this could be workable at the fs level, provided it
deals just with policies and remains hardware-neutral.  However most
of the use cases appear to involve some hardware-dependent knowledge
or assumptions.  What happens when someone sets this on a virtual disk,
or say a (persistent) memory-backed block device?  Case #6 seems to
open up some potential for unexpected interactions (which may be hard
to reproduce, esp. in error/recovery scenarios).

Case #2 takes a devid, but I notice btrfs_device::devid says, "the
internal btrfs device id".  How does a user obtain that internal value
so it can be set as a mount option?

Thanks,
Ed


>>>>> ::
>>>>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>>>>> index 39ba59832f38..478623e6e074 100644
>>>>>>> --- a/fs/btrfs/volumes.c
>>>>>>> +++ b/fs/btrfs/volumes.c
>>>>>>> @@ -5270,6 +5270,16 @@ static int find_live_mirror(struct
>>>>>>> btrfs_fs_info *fs_info,
>>>>>>>             num = map->num_stripes;
>>>>>>>           switch(fs_info->read_mirror_policy) {
>>>>>>> +    case BTRFS_READ_MIRROR_BY_DEV:
>>>>>>> +        optimal = first;
>>>>>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>>>>>> +                 &map->stripes[optimal].dev->dev_state))
>>>>>>> +            break;
>>>>>>> +        if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>>>>>>> +                 &map->stripes[++optimal].dev->dev_state))
>>>>>>> +            break;
>>>>>>> +        optimal = first;
>>>>>>
>>>>>> you set optimal 2 times, the second one seems redundant.
>>>>>
>>>>>    No actually. When both the disks containing the stripe does not
>>>>>    have the BTRFS_DEV_STATE_READ_MIRROR, then I would just want to
>>>>>    use first found stripe.
>>>>
>>>> Yes, and the fact that you've already set optimal = first right after
>>>> BTRFS_READ_MIRROR_BY_DEV ensures that, no ? Why do you need to again
>>>> set
>>>> optimal right before the final break? What am I missing here?
>>>
>>>    Ah. I think you are missing ++optimal in the 2nd if.
>>
>> You are right, but I'd prefer you index the stripes array with 'optimal'
>> and 'optimal + 1' and leave just a single assignment
> 
>  Ok. Will improve that.
> 
> Thanks, Anand
> 
> 
>>>
>>> Thanks, Anand
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

