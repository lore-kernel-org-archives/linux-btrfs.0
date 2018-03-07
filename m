Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49429 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbeCGLPQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 06:15:16 -0500
Subject: Re: [PATCH 1/2] Btrfs: fiemap: pass correct bytenr when
 fm_extent_count is zero
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
 <1520410819-32405-2-git-send-email-robbieko@synology.com>
 <1de45bba-fe15-d1d6-173a-741918399d69@suse.com>
 <c7f76974fefae3f4162ae23335ca9971@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5ebe96aa-35e2-6c48-3ac9-ddf84f1d141d@suse.com>
Date: Wed, 7 Mar 2018 13:15:11 +0200
MIME-Version: 1.0
In-Reply-To: <c7f76974fefae3f4162ae23335ca9971@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.03.2018 12:27, robbieko wrote:
> Nikolay Borisov 於 2018-03-07 18:19 寫到:
>> On  7.03.2018 10:20, robbieko wrote:
>>> From: Robbie Ko <robbieko@synology.com>
>>>
>>>  # mount /dev/vdb5 /mnt/btrfs
>>>  # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
>>>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>  /mnt/btrfs/file:
>>>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>    0: [0..127]:        25088..25215       128   0x1
>>>
>>> Run fiemap with fm_extent_count set to 0, we'll get wrong value 4
>>> instead of 1.
>>
>> Wrong value 4 instead of 1 for which exact column, the flags? State this
>> explicitly.
>>
>> Also this seems a bit bogus since fiemap's documentation states:
>>
>> If fm_extent_count is zero, then the fm_extents[] array is ignored (no
>> extents will be returned), and the fm_mapped_extents count will hold the
>> number of extents needed in fm_extents[] to hold the file's current
>> mapping.
>>
>> So when fm_extent_count we shouldn't really be returning anything from
>> kernel.
>>
> 
> Sorry I did not explain clearly.
> The value is fm_mapped_extents.

But fm_mapped_extents is tagged as an OUT member, meaning the user has
no job writing to it.

> If fm_extent_count  is zero, the fm_mapped_extents count will hold the
> number of extents needed.
> 
> 
>>
>>>
>>> [REASON]
>>> When fm_extent_count is 0, disko is not initialized correctly,
>>> The value is 0 in this case, not the right bytenr.
>>
>> This is too sparse, be more explicit i.e. that disko=0 is passed to
>> emit_fiemap_extent which then leads to issues.
>>
>>>
>>> [FIX]
>>> Use correct disko.
>>>
>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>> ---
>>>  fs/btrfs/extent_io.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index 012d638..066b6df 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -4567,7 +4567,7 @@ int extent_fiemap(struct inode *inode, struct
>>> fiemap_extent_info *fieinfo,
>>>              offset_in_extent = em_start - em->start;
>>>          em_end = extent_map_end(em);
>>>          em_len = em_end - em_start;
>>> -        disko = 0;
>>> +        disko = em->block_start + offset_in_extent;
>>>          flags = 0;
>>>
>>>          /*
>>> @@ -4590,8 +4590,6 @@ int extent_fiemap(struct inode *inode, struct
>>> fiemap_extent_info *fieinfo,
>>>              u64 bytenr = em->block_start -
>>>                  (em->start - em->orig_start);
>>>
>>> -            disko = em->block_start + offset_in_extent;
>>> -
>>>              /*
>>>               * As btrfs supports shared space, this information
>>>               * can be exported to userspace tools via
>>> -- 
>>> 1.9.1
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
