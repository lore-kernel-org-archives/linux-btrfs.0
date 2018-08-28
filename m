Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:52528 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727712AbeH1RVD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 13:21:03 -0400
Subject: Re: Scrub aborts due to corrupt leaf
From: Larkin Lowrey <llowrey@nuclearwinter.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
Message-ID: <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
Date: Tue, 28 Aug 2018 09:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>
>>> The system uses ECC memory and edac-util has not reported any errors.
>>> However, I will run a memtest anyway.
>> So it should not be the memory problem.
>>
>> BTW, what's the current generation of the fs?
>>
>> # btrfs inspect dump-super <device> | grep generation
>>
>> The corrupted leaf has generation 2862, I'm not sure how recent did the
>> corruption happen.
>
> generation              358392
> chunk_root_generation   357256
> cache_generation        358392
> uuid_tree_generation    358392
> dev_item.generation     0
>
> I don't recall the last time I ran a scrub but I doubt it has been 
> more than a year.
>
> I am running 'btrfs check --init-csum-tree' now. Hopefully that clears 
> everything up.

No such luck:

Creating a new CRC tree
Checking filesystem on /dev/Cached/Backups
UUID: acff5096-1128-4b24-a15e-4ba04261edc3
Reinitialize checksum tree
csum result is 0 for block 2412149436416
extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -28
btrfs(+0x1da16)[0x55cc43796a16]
btrfs(btrfs_alloc_free_block+0x207)[0x55cc4379c177]
btrfs(+0x1602f)[0x55cc4378f02f]
btrfs(btrfs_search_slot+0xed2)[0x55cc43790be2]
btrfs(btrfs_csum_file_block+0x48f)[0x55cc437a213f]
btrfs(+0x55cef)[0x55cc437cecef]
btrfs(cmd_check+0xd49)[0x55cc437ddbc9]
btrfs(main+0x81)[0x55cc4378b4d1]
/lib64/libc.so.6(__libc_start_main+0xeb)[0x7f4717e6324b]
btrfs(_start+0x2a)[0x55cc4378b5ea]
Aborted (core dumped)

--Larkin
