Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40582 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbeH1Rrw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 13:47:52 -0400
Received: by mail-lf1-f65.google.com with SMTP id x26-v6so1453240lfi.7
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 06:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com> <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Aug 2018 07:56:02 -0600
Message-ID: <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 7:42 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018/8/28 下午9:29, Larkin Lowrey wrote:
>> On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
>>> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>>>
>>>>> The system uses ECC memory and edac-util has not reported any errors.
>>>>> However, I will run a memtest anyway.
>>>> So it should not be the memory problem.
>>>>
>>>> BTW, what's the current generation of the fs?
>>>>
>>>> # btrfs inspect dump-super <device> | grep generation
>>>>
>>>> The corrupted leaf has generation 2862, I'm not sure how recent did the
>>>> corruption happen.
>>>
>>> generation              358392
>>> chunk_root_generation   357256
>>> cache_generation        358392
>>> uuid_tree_generation    358392
>>> dev_item.generation     0
>>>
>>> I don't recall the last time I ran a scrub but I doubt it has been
>>> more than a year.
>>>
>>> I am running 'btrfs check --init-csum-tree' now. Hopefully that clears
>>> everything up.
>>
>> No such luck:
>>
>> Creating a new CRC tree
>> Checking filesystem on /dev/Cached/Backups
>> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
>> Reinitialize checksum tree
>> csum result is 0 for block 2412149436416
>> extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -28
>
> It's ENOSPC, meaning btrfs can't find enough space for the new csum tree
> blocks.

Seems bogus, there's >4TiB unallocated.

>Label: none  uuid: acff5096-1128-4b24-a15e-4ba04261edc3
>        Total devices 1 FS bytes used 66.61TiB
>        devid    1 size 72.77TiB used 68.03TiB path /dev/mapper/Cached-Backups
>
>Data, single: total=67.80TiB, used=66.52TiB
>System, DUP: total=40.00MiB, used=7.41MiB
>Metadata, DUP: total=98.50GiB, used=95.21GiB
>GlobalReserve, single: total=512.00MiB, used=0.00B

Even if all metadata is only csum tree, and ~200GiB needs to be
written, there's plenty of free space for it.



-- 
Chris Murphy
