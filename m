Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41720 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S964919AbdDTCQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 22:16:55 -0400
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170420012509.GB15096@lim.localdomain>
 <98ab28d8-7ab6-0d2d-92d6-38b78e572d39@cn.fujitsu.com>
 <20170420020817.GD15096@lim.localdomain>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ec490372-8554-5b43-ea44-57a4d36a25da@cn.fujitsu.com>
Date: Thu, 20 Apr 2017 10:16:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170420020817.GD15096@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/20/2017 10:08 AM, Liu Bo wrote:
> On Thu, Apr 20, 2017 at 09:52:00AM +0800, Qu Wenruo wrote:
>>
>>
>> At 04/20/2017 09:25 AM, Liu Bo wrote:
>>> On Fri, Apr 07, 2017 at 10:43:15AM +0800, Qu Wenruo wrote:
>>>> [BUG]
>>>> Cycle mount btrfs can cause fiemap to return different result.
>>>> Like:
>>>>    # mount /dev/vdb5 /mnt/btrfs
>>>>    # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
>>>>    # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>    /mnt/test/file:
>>>>    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>      0: [0..127]:        25088..25215       128   0x1
>>>>    # umount /mnt/btrfs
>>>>    # mount /dev/vdb5 /mnt/btrfs
>>>>    # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>    /mnt/test/file:
>>>>    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>      0: [0..31]:         25088..25119        32   0x0
>>>>      1: [32..63]:        25120..25151        32   0x0
>>>>      2: [64..95]:        25152..25183        32   0x0
>>>>      3: [96..127]:       25184..25215        32   0x1
>>>> But after above fiemap, we get correct merged result if we call fiemap
>>>> again.
>>>>    # xfs_io -c "fiemap -v" /mnt/btrfs/file
>>>>    /mnt/test/file:
>>>>    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>>>>      0: [0..127]:        25088..25215       128   0x1
>>>>
>>>> [REASON]
>>>> Btrfs will try to merge extent map when inserting new extent map.
>>>>
>>>> btrfs_fiemap(start=0 len=(u64)-1)
>>>> |- extent_fiemap(start=0 len=(u64)-1)
>>>>      |- get_extent_skip_holes(start=0 len=64k)
>>>>      |  |- btrfs_get_extent_fiemap(start=0 len=64k)
>>>>      |     |- btrfs_get_extent(start=0 len=64k)
>>>>      |        |  Found on-disk (ino, EXTENT_DATA, 0)
>>>>      |        |- add_extent_mapping()
>>>>      |        |- Return (em->start=0, len=16k)
>>>>      |
>>>>      |- fiemap_fill_next_extent(logic=0 phys=X len=16k)
>>>>      |
>>>>      |- get_extent_skip_holes(start=0 len=64k)
>>>>      |  |- btrfs_get_extent_fiemap(start=0 len=64k)
>>>>      |     |- btrfs_get_extent(start=16k len=48k)
>>>>      |        |  Found on-disk (ino, EXTENT_DATA, 16k)
>>>>      |        |- add_extent_mapping()
>>>>      |        |  |- try_merge_map()
>>>>      |        |     Merge with previous em start=0 len=16k
>>>>      |        |     resulting em start=0 len=32k
>>>>      |        |- Return (em->start=0, len=32K)    << Merged result
>>>>      |- Stripe off the unrelated range (0~16K) of return em
>>>>      |- fiemap_fill_next_extent(logic=16K phys=X+16K len=16K)
>>>>         ^^^ Causing split fiemap extent.
>>>>
>>>> And since in add_extent_mapping(), em is already merged, in next
>>>> fiemap() call, we will get merged result.
>>>>
>>>> [FIX]
>>>> Here we introduce a new structure, fiemap_cache, which records previous
>>>> fiemap extent.
>>>>
>>>> And will always try to merge current fiemap_cache result before calling
>>>> fiemap_fill_next_extent().
>>>> Only when we failed to merge current fiemap extent with cached one, we
>>>> will call fiemap_fill_next_extent() to submit cached one.
>>>>
>>>> So by this method, we can merge all fiemap extents.
>>>>
>>>
>>> If I understand it correctly, what it's missing currently is 'merge', a
>>> straightfoward idea is to make use of the 'merge' ability of btrfs_get_extent. >
>>> Since btrfs_get_extent_fiemap is a wrapper of btrfs_get_extent, does it make
>>> sense if we make btrfs_get_extent_fiemap iterate all extent maps within the
>>> range passing to it or just one more extent map to check if btrfs_get_extent
>>> could return a merged extent map before returning?
>>
>> So your idea to to do the merging inside btrfs_get_extent(), instead of
>> merging it in extent_fiemap()?
>>
>> In theory, they have the same effect for fiemap.
>> And that's my original idea.
>>
>> But the problem is, btrfs_get_extent() is called almost everywhere, more
>> frequently than extent_fiemap(), the extra time used to merging extent map
>> may cause performance problem.
>>
>> For the worst case, if a file is made up by 262144 4K extent (takes up 1G),
>> btrfs_get_extent() call on the file will iterate all these extents,
>> which will iterate more than 500 16K tree blocks.
>>
>> If only fiemap takes such longer time, it's still acceptable. But if
>> btrfs_get_extent() takes such longer time, I think it will be a problem
>> then.
>>
> 
> Not related to the patch, but the question is, does fiemap ioctl think
> it is important to have unified output?

Not defined by any one nor documentation.

But wouldn't it be strange that fiemap returns different result even we 
had done nothing?

As XFS can do it well, why not Btrfs?
(BTW, it seems that XFS does it even better, merge ondisk extents at 
insert time, other than do tricks in fiemap routine)

Thanks,
Qu

> 
> The filefrag manual only says it's attempting to get extent
> information.  And this inconsistent output of filefrag doesn't seem to
> confusing users as the reported extent count is correct.
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Thanks,
> 
> -liubo
> 
> 


