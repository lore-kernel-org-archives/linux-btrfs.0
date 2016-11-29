Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36299 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbcK2SrV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 13:47:21 -0500
Received: by mail-yb0-f174.google.com with SMTP id v78so10404142ybe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 10:47:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <07d2e8cf-fb23-b2f1-cc69-f329d8347301@cn.fujitsu.com>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com> <20161129035355.GQ8685@hungrycats.org>
 <4270b44d-7336-cd22-104a-c79058955757@cn.fujitsu.com> <20161129045537.GR8685@hungrycats.org>
 <07d2e8cf-fb23-b2f1-cc69-f329d8347301@cn.fujitsu.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 29 Nov 2016 19:47:05 +0100
Message-ID: <CANznX5HL5+j75BX=C10vd0L4Q3rJhMQmTMwEqgxk_0Y+whcFOQ@mail.gmail.com>
Subject: Re: RFC: raid with a variable stripe size
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Zygo Blaxell <zblaxell@furryterror.org>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I would love to have the stripe element size (per disk portions of
logical "full" stripes) changeable online with balance anyway
(starting from 512 byte/disk, not placing artificial arbitrary
limitations on it at the low end).
A small stripe size (for example 4k/disk or even 512byte/disk if you
happen to have HDDs with real 512 byte physical sectors) would help
minimizing this temporal space waste problem a lot (16 fold if you go
from 64k to 4k, or even completely if you go down to 512 byte on
5-disk RAID-5).

And regardless of that, I think having to keep in mind to balance
regularly, or even artificially running out of space from time to time
is much better than living with a constantly impending doom in mind
(and probably experiencing that disaster for real in your lifetime).

In case you wonder and/or care, ZFS not only allows for setting the
parameter which is closest to the "stripe element size" (smallest unit
which can be written to a disk at once) to 512 byte but that still
continues to be the default for many ZFS implementations, with 4k (or
more) being only optional (it's controlled by "ashift" and set
statically on pool creation time, although additional cache/log
devices might be added later with different ashift). And I like it
that way. I never used bigger ashift than the one matching the
physical sector size of the disks (usually 512 byte for HDDs or 4k for
SSDs). And I always used the smallest recordsize (effectively the
minimum "full" stripe stripe) I could get around with before notably
throttling the performance of sustained sequential writes. In this
regard, I never understood why people tend to crave huge units like
1MiB stripe size or so. Don't they ever store small files or read
small chunks of big files and/or care about latency (and even
minimizing the potential data loss in case multiple random sectors get
damaged on multiple disks, or upon power failure / kernel panic), not
even as long as benchmarks can show it's almost free to go lower...?

On Tue, Nov 29, 2016 at 6:49 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 11/29/2016 12:55 PM, Zygo Blaxell wrote:
>>
>> On Tue, Nov 29, 2016 at 12:12:03PM +0800, Qu Wenruo wrote:
>>>
>>>
>>>
>>> At 11/29/2016 11:53 AM, Zygo Blaxell wrote:
>>>>
>>>> On Tue, Nov 29, 2016 at 08:48:19AM +0800, Qu Wenruo wrote:
>>>>>
>>>>> At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> these are only my thoughts; no code here, but I would like to share it
>>>>>> hoping that it could be useful.
>>>>>>
>>>>>> As reported several times by Zygo (and others), one of the problem
>>>>>
>>>>> of raid5/6 is the write hole. Today BTRFS is not capable to address it.
>>>>>
>>>>> I'd say, no need to address yet, since current soft RAID5/6 can't
>>>>> handle it
>>>>> yet.
>>>>>
>>>>> Personally speaking, Btrfs should implementing RAID56 support just like
>>>>> Btrfs on mdadm.
>>>>
>>>>
>>>> Even mdadm doesn't implement it the way btrfs does (assuming all bugs
>>>> are fixed) any more.
>>>>
>>>>> See how badly the current RAID56 works?
>>>>
>>>>
>>>>> The marginally benefit of btrfs RAID56 to scrub data better than
>>>>> tradition
>>>>> RAID56 is just a joke in current code base.
>>>>
>>>>
>>>>>> The problem is that the stripe size is bigger than the "sector size"
>>>>>
>>>>> (ok sector is not the correct word, but I am referring to the basic
>>>>> unit of writing on the disk, which is 4k or 16K in btrfs).  >So when
>>>>> btrfs writes less data than the stripe, the stripe is not filled; when
>>>>> it is filled by a subsequent write, a RMW of the parity is required.
>>>>>>
>>>>>>
>>>>>> On the best of my understanding (which could be very wrong) ZFS try
>>>>>
>>>>> to solve this issue using a variable length stripe.
>>>>>
>>>>> Did you mean ZFS record size?
>>>>> IIRC that's file extent minimum size, and I didn't see how that can
>>>>> handle
>>>>> the write hole problem.
>>>>>
>>>>> Or did ZFS handle the problem?
>>>>
>>>>
>>>> ZFS's strategy does solve the write hole.  In btrfs terms, ZFS embeds
>>>> the
>>>> parity blocks within extents, so it behaves more like btrfs compression
>>>> in the sense that the data in a RAID-Z extent is encoded differently
>>>
>>> >from the data in the file, and the kernel has to transform it on reads
>>>>
>>>> and writes.
>>>>
>>>> No ZFS stripe can contain blocks from multiple different
>>>> transactions because the RAID-Z stripes begin and end on extent
>>>> (single-transaction-write) boundaries, so there is no write hole on ZFS.
>>>>
>>>> There is some space waste in ZFS because the minimum allocation unit
>>>> is two blocks (one data one parity) so any free space that is less
>>>> than two blocks long is unusable.  Also the maximum usable stripe width
>>>> (number of disks) is the size of the data in the extent plus one parity
>>>> block.  It means if you write a lot of discontiguous 4K blocks, you
>>>> effectively get 2-disk RAID1 and that may result in disappointing
>>>> storage efficiency.
>>>>
>>>> (the above is for RAID-Z1.  For Z2 and Z3 add an extra block or two
>>>> for additional parity blocks).
>>>>
>>>> One could implement RAID-Z on btrfs, but it's by far the most invasive
>>>> proposal for fixing btrfs's write hole so far (and doesn't actually fix
>>>> anything, since the existing raid56 format would still be required to
>>>> read old data, and it would still be broken).
>>>>
>>>>> Anyway, it should be a low priority thing, and personally speaking,
>>>>> any large behavior modification involving  both extent allocator and bg
>>>>> allocator will be bug prone.
>>>>
>>>>
>>>> My proposal requires only a modification to the extent allocator.
>>>> The behavior at the block group layer and scrub remains exactly the
>>>> same.
>>>> We just need to adjust the allocator slightly to take the RAID5 CoW
>>>> constraints into account.
>>>
>>>
>>> Then, you'd need to allow btrfs to split large buffered/direct write into
>>> small extents(not 128M anymore).
>>> Not sure if we need to do extra work for DirectIO.
>>
>>
>> Nope, that's not my proposal.  My proposal is to simply ignore free
>> space whenever it's inside a partially filled raid stripe (optimization:
>> ...which was empty at the start of the current transaction).
>
>
> Still have problems.
>
> Allocator must handle fs under device remove or profile converting (from 4
> disks raid5 to 5 disk raid5/6) correctly.
> Which already seems complex for me.
>
>
> And further more, for fs with more devices, for example, 9 devices RAID5.
> It will be a disaster to just write a 4K data and take up the whole 8 * 64K
> space.
> It will  definitely cause huge ENOSPC problem.
>
> If you really think it's easy, make a RFC patch, which should be easy if it
> is, then run fstest auto group on it.
>
> Easy words won't turn emails into real patch.
>
>
>>
>> That avoids modifying a stripe with committed data and therefore plugs the
>> write hole.
>>
>> For nodatacow, prealloc (and maybe directio?) extents the behavior
>> wouldn't change (you'd have write hole, but only on data blocks not
>> metadata, and only on files that were already marked as explicitly not
>> requiring data integrity).
>>
>>> And in fact, you're going to support variant max file extent size.
>>
>>
>> The existing extent sizing behavior is not changed *at all* in my
>> proposal,
>> only the allocator's notion of what space is 'free'.
>>
>> We can write an extent across multiple RAID5 stripes so long as we
>> finish writing the entire extent before pointing committed metadata to
>> it.  btrfs does that already otherwise checksums wouldn't work.
>>
>>> This makes delalloc more complex (Wang enhanced dealloc support for
>>> variant
>>> file extent size, to fix ENOSPC problem for dedupe and compression).
>>>
>>> This is already much more complex than you expected.
>>
>>
>> The complexity I anticipate is having to deal with two implementations
>> of the free space search, one for free space cache and one for free
>> space tree.
>>
>> It could be as simple as calling the existing allocation functions and
>> just filtering out anything that isn't suitably aligned inside a raid56
>> block group (at least for a proof of concept).
>>
>>> And this is the *BIGGEST* problem of current btrfs:
>>> No good enough(if there is any) *ISOLATION* for such a complex fs.
>>>
>>> So even "small" modification can lead to unexpected bugs.
>>>
>>> That's why I want to isolate the fix in RAID56 layer, not any layer
>>> upwards.
>>
>>
>> I don't think the write hole is fixable in the current raid56 layer, at
>> least not without a nasty brute force solution like stripe update journal.
>>
>> Any of the fixes I'd want to use fix the problem from outside.
>>
>>> If not possible, I prefer not to do anything yet, until we are sure the
>>> very
>>> basic part of RAID56 is stable.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> It's not as efficient as the ZFS approach, but it doesn't require an
>>>> incompatible disk format change either.
>>>>
>>>>>> On BTRFS this could be achieved using several BGs (== block group or
>>>>>> chunk), one for each stripe size.
>>>>>>
>>>>>> For example, if a filesystem - RAID5 is composed by 4 DISK, the
>>>>>> filesystem should have three BGs:
>>>>>> BG #1,composed by two disks (1 data+ 1 parity)
>>>>>> BG #2 composed by three disks (2 data + 1 parity)
>>>>>> BG #3 composed by four disks (3 data + 1 parity).
>>>>>
>>>>>
>>>>> Too complicated bg layout and further extent allocator modification.
>>>>>
>>>>> More code means more bugs, and I'm pretty sure it will be bug prone.
>>>>>
>>>>>
>>>>> Although the idea of variable stripe size can somewhat reduce the
>>>>> problem
>>>>> under certain situation.
>>>>>
>>>>> For example, if sectorsize is 64K, and we make stripe len to 32K, and
>>>>> use 3
>>>>> disc RAID5, we can avoid such write hole problem.
>>>>> Withouth modification to extent/chunk allocator.
>>>>>
>>>>> And I'd prefer to make stripe len mkfs time parameter, not possible to
>>>>> modify after mkfs. To make things easy.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> If the data to be written has a size of 4k, it will be allocated to
>>>>>> the BG #1.
>>>>>> If the data to be written has a size of 8k, it will be allocated to
>>>>>> the BG #2
>>>>>> If the data to be written has a size of 12k, it will be allocated to
>>>>>> the BG #3
>>>>>> If the data to be written has a size greater than 12k, it will be
>>>>>> allocated to the BG3, until the data fills a full stripes; then the
>>>>>> remainder will be stored in BG #1 or BG #2.
>>>>>>
>>>>>>
>>>>>> To avoid unbalancing of the disk usage, each BG could use all the
>>>>>> disks, even if a stripe uses less disks: i.e
>>>>>>
>>>>>> DISK1 DISK2 DISK3 DISK4
>>>>>> S1    S1    S1    S2
>>>>>> S2    S2    S3    S3
>>>>>> S3    S4    S4    S4
>>>>>> [....]
>>>>>>
>>>>>> Above is show a BG which uses all the four disks, but has a stripe
>>>>>> which spans only 3 disks.
>>>>>>
>>>>>>
>>>>>> Pro:
>>>>>> - btrfs already is capable to handle different BG in the filesystem,
>>>>>> only the allocator has to change
>>>>>> - no more RMW are required (== higher performance)
>>>>>>
>>>>>> Cons:
>>>>>> - the data will be more fragmented
>>>>>> - the filesystem, will have more BGs; this will require time-to time a
>>>>>> re-balance. But is is an issue which we already know (even if may be not
>>>>>> 100% addressed).
>>>>>>
>>>>>>
>>>>>> Thoughts ?
>>>>>>
>>>>>> BR
>>>>>> G.Baroncelli
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>
>>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
