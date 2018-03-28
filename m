Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeC1HDf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:03:35 -0400
Subject: Re: [PATCH 5/8] btrfs: check if the fsid in the primary sb and copy
 sb are same
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-6-anand.jain@oracle.com>
 <8da9690d-9a4b-2544-be21-0c99f09760f0@suse.com>
 <430fc7dc-1266-e9f4-6453-60bda1e9a82c@oracle.com>
 <7be2ec75-5b5a-7ed5-4fee-23aefae39719@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c820bed0-1603-c8ce-01c0-321dff874cca@oracle.com>
Date: Wed, 28 Mar 2018 15:05:25 +0800
MIME-Version: 1.0
In-Reply-To: <7be2ec75-5b5a-7ed5-4fee-23aefae39719@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





>>>> +    for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>>> +        u64 bytenr = btrfs_sb_offset(i);
>>>> +
>>>> +        ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
>>>> +        if (ret) {
>>>> +            if (i == 0)
>>>> +                goto error_kfree;
>>>> +            /* copy2 is optional */
>>>> +            ret = 0;
>>>> +            continue;
>>>> +        }
>>>> +
>>>> +        if (i == 0) {
>>>> +            memcpy(disk_super_primary, disk_super,
>>>> +                   sizeof(*disk_super_primary));
>>>> +            btrfs_release_disk_super(page);
>>>> +            continue;
>>>
>>> Doing the memcpy is enough here, the bottom of the loop already releases
>>> the disk page and continues on the next iteration.
>>
>>   The page map happens inside btrfs_read_disk_super(), we
>>   need unmap before going for the next superblock.
> 
> You already have  btrfs_release_disk_super(page); called at the end of
> the iteration, right after the closing bracket for the else, see below...

   Ah. You meant only memcpy. Yes.
   This part of the code is completely changed in V2. Thanks.
