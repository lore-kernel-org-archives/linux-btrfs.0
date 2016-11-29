Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755474AbcK2Fup (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 00:50:45 -0500
Subject: Re: RFC: raid with a variable stripe size
To: Zygo Blaxell <zblaxell@furryterror.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
 <20161129035355.GQ8685@hungrycats.org>
 <4270b44d-7336-cd22-104a-c79058955757@cn.fujitsu.com>
 <20161129045537.GR8685@hungrycats.org>
CC: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <07d2e8cf-fb23-b2f1-cc69-f329d8347301@cn.fujitsu.com>
Date: Tue, 29 Nov 2016 13:49:09 +0800
MIME-Version: 1.0
In-Reply-To: <20161129045537.GR8685@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/29/2016 12:55 PM, Zygo Blaxell wrote:
> On Tue, Nov 29, 2016 at 12:12:03PM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/29/2016 11:53 AM, Zygo Blaxell wrote:
>>> On Tue, Nov 29, 2016 at 08:48:19AM +0800, Qu Wenruo wrote:
>>>> At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
>>>>> Hello,
>>>>>
>>>>> these are only my thoughts; no code here, but I would like to share it hoping that it could be useful.
>>>>>
>>>>> As reported several times by Zygo (and others), one of the problem
>>>> of raid5/6 is the write hole. Today BTRFS is not capable to address it.
>>>>
>>>> I'd say, no need to address yet, since current soft RAID5/6 can't handle it
>>>> yet.
>>>>
>>>> Personally speaking, Btrfs should implementing RAID56 support just like
>>>> Btrfs on mdadm.
>>>
>>> Even mdadm doesn't implement it the way btrfs does (assuming all bugs
>>> are fixed) any more.
>>>
>>>> See how badly the current RAID56 works?
>>>
>>>> The marginally benefit of btrfs RAID56 to scrub data better than tradition
>>>> RAID56 is just a joke in current code base.
>>>
>>>>> The problem is that the stripe size is bigger than the "sector size"
>>>> (ok sector is not the correct word, but I am referring to the basic
>>>> unit of writing on the disk, which is 4k or 16K in btrfs).  >So when
>>>> btrfs writes less data than the stripe, the stripe is not filled; when
>>>> it is filled by a subsequent write, a RMW of the parity is required.
>>>>>
>>>>> On the best of my understanding (which could be very wrong) ZFS try
>>>> to solve this issue using a variable length stripe.
>>>>
>>>> Did you mean ZFS record size?
>>>> IIRC that's file extent minimum size, and I didn't see how that can handle
>>>> the write hole problem.
>>>>
>>>> Or did ZFS handle the problem?
>>>
>>> ZFS's strategy does solve the write hole.  In btrfs terms, ZFS embeds the
>>> parity blocks within extents, so it behaves more like btrfs compression
>>> in the sense that the data in a RAID-Z extent is encoded differently
>> >from the data in the file, and the kernel has to transform it on reads
>>> and writes.
>>>
>>> No ZFS stripe can contain blocks from multiple different
>>> transactions because the RAID-Z stripes begin and end on extent
>>> (single-transaction-write) boundaries, so there is no write hole on ZFS.
>>>
>>> There is some space waste in ZFS because the minimum allocation unit
>>> is two blocks (one data one parity) so any free space that is less
>>> than two blocks long is unusable.  Also the maximum usable stripe width
>>> (number of disks) is the size of the data in the extent plus one parity
>>> block.  It means if you write a lot of discontiguous 4K blocks, you
>>> effectively get 2-disk RAID1 and that may result in disappointing
>>> storage efficiency.
>>>
>>> (the above is for RAID-Z1.  For Z2 and Z3 add an extra block or two
>>> for additional parity blocks).
>>>
>>> One could implement RAID-Z on btrfs, but it's by far the most invasive
>>> proposal for fixing btrfs's write hole so far (and doesn't actually fix
>>> anything, since the existing raid56 format would still be required to
>>> read old data, and it would still be broken).
>>>
>>>> Anyway, it should be a low priority thing, and personally speaking,
>>>> any large behavior modification involving  both extent allocator and bg
>>>> allocator will be bug prone.
>>>
>>> My proposal requires only a modification to the extent allocator.
>>> The behavior at the block group layer and scrub remains exactly the same.
>>> We just need to adjust the allocator slightly to take the RAID5 CoW
>>> constraints into account.
>>
>> Then, you'd need to allow btrfs to split large buffered/direct write into
>> small extents(not 128M anymore).
>> Not sure if we need to do extra work for DirectIO.
>
> Nope, that's not my proposal.  My proposal is to simply ignore free
> space whenever it's inside a partially filled raid stripe (optimization:
> ...which was empty at the start of the current transaction).

Still have problems.

Allocator must handle fs under device remove or profile converting (from 
4 disks raid5 to 5 disk raid5/6) correctly.
Which already seems complex for me.


And further more, for fs with more devices, for example, 9 devices RAID5.
It will be a disaster to just write a 4K data and take up the whole 8 * 
64K space.
It will  definitely cause huge ENOSPC problem.

If you really think it's easy, make a RFC patch, which should be easy if 
it is, then run fstest auto group on it.

Easy words won't turn emails into real patch.

>
> That avoids modifying a stripe with committed data and therefore plugs the
> write hole.
>
> For nodatacow, prealloc (and maybe directio?) extents the behavior
> wouldn't change (you'd have write hole, but only on data blocks not
> metadata, and only on files that were already marked as explicitly not
> requiring data integrity).
>
>> And in fact, you're going to support variant max file extent size.
>
> The existing extent sizing behavior is not changed *at all* in my proposal,
> only the allocator's notion of what space is 'free'.
>
> We can write an extent across multiple RAID5 stripes so long as we
> finish writing the entire extent before pointing committed metadata to
> it.  btrfs does that already otherwise checksums wouldn't work.
>
>> This makes delalloc more complex (Wang enhanced dealloc support for variant
>> file extent size, to fix ENOSPC problem for dedupe and compression).
>>
>> This is already much more complex than you expected.
>
> The complexity I anticipate is having to deal with two implementations
> of the free space search, one for free space cache and one for free
> space tree.
>
> It could be as simple as calling the existing allocation functions and
> just filtering out anything that isn't suitably aligned inside a raid56
> block group (at least for a proof of concept).
>
>> And this is the *BIGGEST* problem of current btrfs:
>> No good enough(if there is any) *ISOLATION* for such a complex fs.
>>
>> So even "small" modification can lead to unexpected bugs.
>>
>> That's why I want to isolate the fix in RAID56 layer, not any layer upwards.
>
> I don't think the write hole is fixable in the current raid56 layer, at
> least not without a nasty brute force solution like stripe update journal.
>
> Any of the fixes I'd want to use fix the problem from outside.
>
>> If not possible, I prefer not to do anything yet, until we are sure the very
>> basic part of RAID56 is stable.
>>
>> Thanks,
>> Qu
>>
>>>
>>> It's not as efficient as the ZFS approach, but it doesn't require an
>>> incompatible disk format change either.
>>>
>>>>> On BTRFS this could be achieved using several BGs (== block group or chunk), one for each stripe size.
>>>>>
>>>>> For example, if a filesystem - RAID5 is composed by 4 DISK, the filesystem should have three BGs:
>>>>> BG #1,composed by two disks (1 data+ 1 parity)
>>>>> BG #2 composed by three disks (2 data + 1 parity)
>>>>> BG #3 composed by four disks (3 data + 1 parity).
>>>>
>>>> Too complicated bg layout and further extent allocator modification.
>>>>
>>>> More code means more bugs, and I'm pretty sure it will be bug prone.
>>>>
>>>>
>>>> Although the idea of variable stripe size can somewhat reduce the problem
>>>> under certain situation.
>>>>
>>>> For example, if sectorsize is 64K, and we make stripe len to 32K, and use 3
>>>> disc RAID5, we can avoid such write hole problem.
>>>> Withouth modification to extent/chunk allocator.
>>>>
>>>> And I'd prefer to make stripe len mkfs time parameter, not possible to
>>>> modify after mkfs. To make things easy.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> If the data to be written has a size of 4k, it will be allocated to the BG #1.
>>>>> If the data to be written has a size of 8k, it will be allocated to the BG #2
>>>>> If the data to be written has a size of 12k, it will be allocated to the BG #3
>>>>> If the data to be written has a size greater than 12k, it will be allocated to the BG3, until the data fills a full stripes; then the remainder will be stored in BG #1 or BG #2.
>>>>>
>>>>>
>>>>> To avoid unbalancing of the disk usage, each BG could use all the disks, even if a stripe uses less disks: i.e
>>>>>
>>>>> DISK1 DISK2 DISK3 DISK4
>>>>> S1    S1    S1    S2
>>>>> S2    S2    S3    S3
>>>>> S3    S4    S4    S4
>>>>> [....]
>>>>>
>>>>> Above is show a BG which uses all the four disks, but has a stripe which spans only 3 disks.
>>>>>
>>>>>
>>>>> Pro:
>>>>> - btrfs already is capable to handle different BG in the filesystem, only the allocator has to change
>>>>> - no more RMW are required (== higher performance)
>>>>>
>>>>> Cons:
>>>>> - the data will be more fragmented
>>>>> - the filesystem, will have more BGs; this will require time-to time a re-balance. But is is an issue which we already know (even if may be not 100% addressed).
>>>>>
>>>>>
>>>>> Thoughts ?
>>>>>
>>>>> BR
>>>>> G.Baroncelli
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>
>>


