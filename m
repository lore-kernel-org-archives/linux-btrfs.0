Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60398 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdIBEDh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Sep 2017 00:03:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dnzeV-0008Be-IB
        for linux-btrfs@vger.kernel.org; Sat, 02 Sep 2017 06:03:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
Date: Sat, 2 Sep 2017 04:03:06 +0000 (UTC)
Message-ID: <pan$9833c$c04b7334$d8bed9c4$4b7b46fb@cox.net>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
        <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
        <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
        <20381200-2f35-2edc-a20b-8852744ed050@gmx.com>
        <c3b7396a-f3c6-40e8-f85e-32fa1150046c@gmail.com>
        <d819f106-b073-444d-7d71-1eff2bd3a896@gmx.com>
        <eebf3457-9ba2-6267-9d75-dc5752cab11f@gmail.com>
        <49c0e633-bb3f-714a-0ef6-48dfa2133bd6@gmx.com>
        <fb4721b1-1c79-73fb-405a-cfc8fa4d710c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 01 Sep 2017 10:07:47 -0400 as
excerpted:

>  On 2017-09-01 09:54, Qu Wenruo wrote:
>> 
>> On 2017年09月01日 20:47, Austin S. Hemmelgarn wrote:

>>> On 2017-09-01 08:19, Qu Wenruo wrote:
>>>>
>>>> Current kernel (and btrfs-progs also tries to follow kernel chunk
>>>> allocator's behavior) will not make a chunk larger than 10% of RW
>>>> space.
>>>> So for small filesystem chunk won't be too maximally sized.

>>> Are you sure about this?  I've got a couple of sub 10GB BTRFS volumes
>>> that definitely have more than one 1GB data chunk.
>> 
>> Yes, check the following code:
>> 
>>          /* we don't want a chunk larger than 10% of writeable space */
>>          max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
>>                               max_chunk_size);
>>
>> Which is in __btrfs_alloc_chunk() function in fs/btrfs/volumes.c

> Huh, I may have the remnants of an old bug present on those filesystems
> then, I'll have to look further into this.

Please do.

While I redid my /boot (and backups on other devices) when I upgraded to
all-ssd, and my /boot is now 512 MiB, with what appears to be a 64 MiB
first-chunk (mixed-bg mode so data/metadata), doubled due to dup-mode to
128 MiB, and while that works out to 1/8=12.5% of the filesystem size,
it still rebalances just fine as long as there's still 128 MiB unallocated
to create the new chunks to write into.

But my earlier layout had a 256 MiB /boot (and backups), and the initial
chunk size was *STILL* 64 MiB, dup to 128 MiB, half the 256 MiB filesystem
size so obviously no balance of that chunk possible because there's not
enough space left after the system chunk takes its byte as well, to write
the new copy of the chunk (and its dup) into.

Now the last time I redid the old layout /boot with a mkfs.btrfs was
several kernel and userspace cycles ago now, so mkfs.btrfs might well have
changed and now creates smaller chunks on a 256 MiB filesystem, but it
sure was frustrating not to be able to rebalance that chunk, and I don't
/know/ that the bug was fixed, because I have the larger /boot now.  Tho
as I said even there it's apparently 1/8, 12.5%, larger than the 10%
quoted, yet I know 32 MiB and I believe even 16 MiB chunks are possible,
tho I'm not sure what the exact minimum is.

Anyway, be sure and check mixed-mode too, because that's where I had my
problems, tho I'm not sure if it's where you had yours.  But it could be
that the differing code path of mixed-mode misses that 10% check, which
would explain my problem, and possibly yours if that's what yours were.

Meanwhile, I might have some free time to do my own checks tomorrow.
It'd be worth it just to my own peace of mind to settle the issue,
since it frustrated me for so long.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

