Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42946 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754018AbdIED6f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 23:58:35 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dp50A-0005j3-JF
        for linux-btrfs@vger.kernel.org; Tue, 05 Sep 2017 05:58:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
Date: Tue, 5 Sep 2017 03:57:56 +0000 (UTC)
Message-ID: <pan$8861e$4d63ba40$47e0003f$7600c860@cox.net>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
        <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
        <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
        <20381200-2f35-2edc-a20b-8852744ed050@gmx.com>
        <c3b7396a-f3c6-40e8-f85e-32fa1150046c@gmail.com>
        <d819f106-b073-444d-7d71-1eff2bd3a896@gmx.com>
        <eebf3457-9ba2-6267-9d75-dc5752cab11f@gmail.com>
        <49c0e633-bb3f-714a-0ef6-48dfa2133bd6@gmx.com>
        <fb4721b1-1c79-73fb-405a-cfc8fa4d710c@gmail.com>
        <pan$9833c$c04b7334$d8bed9c4$4b7b46fb@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sat, 02 Sep 2017 04:03:06 +0000 as excerpted:

> Austin S. Hemmelgarn posted on Fri, 01 Sep 2017 10:07:47 -0400 as
> excerpted:
> 
>>  On 2017-09-01 09:54, Qu Wenruo wrote:
>>> 
>>> On 2017年09月01日 20:47, Austin S. Hemmelgarn wrote:
> 
>>>> On 2017-09-01 08:19, Qu Wenruo wrote:
>>>>>
>>>>> Current kernel (and btrfs-progs also tries to follow kernel chunk
>>>>> allocator's behavior) will not make a chunk larger than 10% of RW
>>>>> space.
>>>>> So for small filesystem chunk won't be too maximally sized.
> 
>>>> Are you sure about this?  I've got a couple of sub 10GB BTRFS volumes
>>>> that definitely have more than one 1GB data chunk.
>>> 
>>> Yes, check the following code:
>>> 
>>>          /* we don't want a chunk larger than 10% of writeable
>>>          space */
>>>          max_chunk_size = min(div_factor(fs_devices->total_rw_bytes,
>>>          1),
>>>                               max_chunk_size);
>>>
>>> Which is in __btrfs_alloc_chunk() function in fs/btrfs/volumes.c
> 
>> Huh, I may have the remnants of an old bug present on those filesystems
>> then, I'll have to look further into this.
> 
> Please do.

> Meanwhile, I might have some free time to do my own checks tomorrow.
> It'd be worth it just to my own peace of mind to settle the issue,
> since it frustrated me for so long.

Just finished testing, and no, as of btrfs-progs 4.12, mkfs.btrfs does 
*NOT* always limit chunk sizes to 1/10 filesystem size, despite smaller 
chunk sizes being available.

Try this.

256 MiB partition.

mkfs.btrfs -d dup -m dup -O extref,skinny-metadata,no-holes --mixed 
<device>

mkfs.btrfs will create a 64 MiB mixed-mode chunk, a quarter the 256 MiB 
filesystem size, duped to 128 MiB, half the filesystem size.

That chunk cannot be balanced because there's no room for the write-into 
chunk and its dup on the filesystem, due to the system chunk of several 
MiB taking up part of the other half.

This despite further writes creating smaller chunks, so it's definitely 
possible to have 32 MiB and I believe 16 MiB chunks (at least, don't know 
if smaller is possible).

So as of -progs 4.12 at least, whatever code is there to try to keep 
mkfs.btrfs max chunk size under 10% of the filesystem size, is broken, at 
least for some configurations (check mixed-mode, sub-GiB).

So I'm glad I upsized /boot to half a GiB when I upgraded SSDs and redid 
my layout.  At least with half a gig, 64 MiB (still 12.5%, over the 10% 
limit) doubled to 128 MiB is still only a quarter the filesystem size, so 
rebalancing is actually possible.

(FWIW my /var/log is still 256 MiB per device, but it's raid1, so only a 
single copy of each chunk per device, and the 64 MiB chunk size is only a 
quarter of the device, so it can at least still be balanced, even with 
chunks more than double the broken 10% ceiling.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

