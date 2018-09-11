Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:54656 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeIKUXV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:23:21 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
From: Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
Date: Tue, 11 Sep 2018 11:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/29/2018 1:32 AM, Qu Wenruo wrote:
>
> On 2018/8/28 下午9:56, Chris Murphy wrote:
>> On Tue, Aug 28, 2018 at 7:42 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>> On 2018/8/28 下午9:29, Larkin Lowrey wrote:
>>>> On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
>>>>> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>>>>>> The system uses ECC memory and edac-util has not reported any errors.
>>>>>>> However, I will run a memtest anyway.
>>>>>> So it should not be the memory problem.
>>>>>>
>>>>>> BTW, what's the current generation of the fs?
>>>>>>
>>>>>> # btrfs inspect dump-super <device> | grep generation
>>>>>>
>>>>>> The corrupted leaf has generation 2862, I'm not sure how recent did the
>>>>>> corruption happen.
>>>>> generation              358392
>>>>> chunk_root_generation   357256
>>>>> cache_generation        358392
>>>>> uuid_tree_generation    358392
>>>>> dev_item.generation     0
>>>>>
>>>>> I don't recall the last time I ran a scrub but I doubt it has been
>>>>> more than a year.
>>>>>
>>>>> I am running 'btrfs check --init-csum-tree' now. Hopefully that clears
>>>>> everything up.
>>>> No such luck:
>>>>
>>>> Creating a new CRC tree
>>>> Checking filesystem on /dev/Cached/Backups
>>>> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
>>>> Reinitialize checksum tree
>>>> csum result is 0 for block 2412149436416
>>>> extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -28
>>> It's ENOSPC, meaning btrfs can't find enough space for the new csum tree
>>> blocks.
>> Seems bogus, there's >4TiB unallocated.
> What a shame.
> Btrfs won't try to allocate new chunk if we're allocating new tree
> blocks for metadata trees (extent, csum, etc).
>
> One quick (and dirty) way to avoid such limitation is to use the
> following patch

> <<patch removed>>

No luck.

# ./btrfs check --init-csum-tree /dev/Cached/Backups
Creating a new CRC tree
Opening filesystem to check...
Checking filesystem on /dev/Cached/Backups
UUID: acff5096-1128-4b24-a15e-4ba04261edc3
Reinitialize checksum tree
Segmentation fault (core dumped)

  btrfs[16575]: segfault at 7ffc4f74ef60 ip 000000000040d4c3 sp 
00007ffc4f74ef50 error 6 in btrfs[400000+bf000]

# ./btrfs --version
btrfs-progs v4.17.1

I cloned  btrfs-progs from git and applied your patch.

BTW, I've been having tons of trouble with two hosts after updating from 
kernel 4.17.12 to 4.17.14 and beyond. The fs will become unresponsive 
and all processes will end up stuck waiting on io. The system will end 
up totally idle but unable perform any io on the filesystem. So far 
things have been stable after reverting back to 4.17.12. It looks like 
there was a btrfs change in 4.17.13. Could that be related to this csum 
tree corruption?

--Larkin
