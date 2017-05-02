Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55971 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750728AbdEBAUJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 20:20:09 -0400
Subject: Re: [PATCH v3.1 1/7] btrfs: Introduce a function to check if all
 chunks a OK for degraded rw mount
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170309013442.19957-2-quwenruo@cn.fujitsu.com>
 <f01fd9f3-85fe-c390-5358-be8c5d67ebc6@oracle.com>
 <4b9409a0-290a-02d4-4288-2b66c1ed0cd6@cn.fujitsu.com>
 <20170501132138.0bd3e33a@job>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d5114574-3c92-dc2c-8326-c109dab24ec1@cn.fujitsu.com>
Date: Tue, 2 May 2017 08:20:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170501132138.0bd3e33a@job>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/01/2017 06:21 PM, Dmitrii Tcvetkov wrote:
>>>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +    struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>>> +    struct extent_map *em;
>>>> +    u64 next_start = 0;
>>>> +    bool ret = true;
>>>> +
>>>> +    read_lock(&map_tree->map_tree.lock);
>>>> +    em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
>>>> +    read_unlock(&map_tree->map_tree.lock);
>>>> +    /* No chunk at all? Return false anyway */
>>>> +    if (!em) {
>>>> +        ret = false;
>>>> +        goto out;
>>>> +    }
>>>> +    while (em) {
>>>> +        struct map_lookup *map;
>>>> +        int missing = 0;
>>>> +        int max_tolerated;
>>>> +        int i;
>>>> +
>>>> +        map = (struct map_lookup *) em->bdev;
>>>
>>>
>>>     any idea why not   map = em->map_lookup;  here?
>>
>>
>> My fault, will update the patch.
>>
>> Thanks,
>> Qu
> 
> Sorry to bother, but looks like this patchset suddenly got forgotten.
> It still applies to 4.11 but I'm afraid it won't after 4.12 merge
> window. Any update on it?

Just waiting for the flush error rework from Anand Jain.

(Well, I still remember the original patchset has the same thing problem)

Maybe Anand Jain has some idea on this.

Thanks,
Qu


