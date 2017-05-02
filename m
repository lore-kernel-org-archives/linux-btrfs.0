Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40834 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdEBCXR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 22:23:17 -0400
Subject: Re: [PATCH v3.1 1/7] btrfs: Introduce a function to check if all
 chunks a OK for degraded rw mount
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170309013442.19957-2-quwenruo@cn.fujitsu.com>
 <f01fd9f3-85fe-c390-5358-be8c5d67ebc6@oracle.com>
 <4b9409a0-290a-02d4-4288-2b66c1ed0cd6@cn.fujitsu.com>
 <20170501132138.0bd3e33a@job>
 <d5114574-3c92-dc2c-8326-c109dab24ec1@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
Message-ID: <8b6d8e7f-df6d-3878-eeb7-533db97db3c5@oracle.com>
Date: Tue, 2 May 2017 10:28:25 +0800
MIME-Version: 1.0
In-Reply-To: <d5114574-3c92-dc2c-8326-c109dab24ec1@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/02/2017 08:20 AM, Qu Wenruo wrote:
>
>
> At 05/01/2017 06:21 PM, Dmitrii Tcvetkov wrote:
>>>>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
>>>>> +{
>>>>> +    struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>>>> +    struct extent_map *em;
>>>>> +    u64 next_start = 0;
>>>>> +    bool ret = true;
>>>>> +
>>>>> +    read_lock(&map_tree->map_tree.lock);
>>>>> +    em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
>>>>> +    read_unlock(&map_tree->map_tree.lock);
>>>>> +    /* No chunk at all? Return false anyway */
>>>>> +    if (!em) {
>>>>> +        ret = false;
>>>>> +        goto out;
>>>>> +    }
>>>>> +    while (em) {
>>>>> +        struct map_lookup *map;
>>>>> +        int missing = 0;
>>>>> +        int max_tolerated;
>>>>> +        int i;
>>>>> +
>>>>> +        map = (struct map_lookup *) em->bdev;
>>>>
>>>>
>>>>     any idea why not   map = em->map_lookup;  here?
>>>
>>>
>>> My fault, will update the patch.
>>>
>>> Thanks,
>>> Qu
>>
>> Sorry to bother, but looks like this patchset suddenly got forgotten.
>> It still applies to 4.11 but I'm afraid it won't after 4.12 merge
>> window. Any update on it?
>
> Just waiting for the flush error rework from Anand Jain.


   There were quite a number of trials on the btrfs dev flush to get
   that correctly, David reviewed previous once and the current and
   probably the final is titled [1] which is waiting for David.
     [1]
     [PATCH] btrfs: add framework to handle device flush error as a volume

Thanks, Anand


> (Well, I still remember the original patchset has the same thing problem)
>
> Maybe Anand Jain has some idea on this.
>
> Thanks,
> Qu




