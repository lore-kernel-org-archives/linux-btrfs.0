Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34953 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdHCRXP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 13:23:15 -0400
Received: by mail-io0-f177.google.com with SMTP id m88so9499476iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 10:23:15 -0700 (PDT)
Subject: Re: Massive loss of disk space
To: kreijack@inwind.it, pwm <pwm@iapetus.neab.net>,
        Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
 <6dc6ca6a-7f55-4176-e2b7-ae8ab69eca00@gmail.com>
 <f227b82c-171a-4475-e08c-6abb53de51f2@inwind.it>
 <0abbc952-99d1-8b23-41ee-f58afca11d08@gmail.com>
 <cab4df59-a5ce-9944-22cb-367173dab108@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8344dc9f-d213-b2d8-5b6c-5c1a54041ef1@gmail.com>
Date: Thu, 3 Aug 2017 13:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <cab4df59-a5ce-9944-22cb-367173dab108@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 12:37, Goffredo Baroncelli wrote:
> On 2017-08-03 13:39, Austin S. Hemmelgarn wrote:
>> On 2017-08-02 17:05, Goffredo Baroncelli wrote:
>>> On 2017-08-02 21:10, Austin S. Hemmelgarn wrote:
>>>> On 2017-08-02 13:52, Goffredo Baroncelli wrote:
>>>>> Hi,
>>>>>
>>> [...]
>>>
>>>>> consider the following scenario:
>>>>>
>>>>> a) create a 2GB file
>>>>> b) fallocate -o 1GB -l 2GB
>>>>> c) write from 1GB to 3GB
>>>>>
>>>>> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
>>>
>>>> There is also an expectation based on pretty much every other FS in existence that calling fallocate() on a range that is already in use is a (possibly expensive) no-op, and by extension using fallocate() with an offset of 0 like a ftruncate() call will succeed as long as the new size will fit.
>>>
>>> The man page of fallocate doesn't guarantee that.
>>>
>>> Unfortunately in a COW filesystem the assumption that an allocate area may be simply overwritten is not true.
>>>
>>> Let me to say it with others words: as general rule if you want to _write_ something in a cow filesystem, you need space. Doesn't matter if you are *over-writing* existing data or you are *appending* to a file.
>> Yes, you need space, but you don't need _all_ the space.  For a file that already has data in it, you only _need_ as much space as the largest chunk of data that can be written at once at a low level, because the moment that first write finishes, the space that was used in the file for that region is freed, and the next write can go there.  Put a bit differently, you only need to allocate what isn't allocated in the region, and then a bit more to handle the initial write to the file.
>>
>> Also, as I said below, _THIS WORKS ON ZFS_.  That immediately means that a CoW filesystem _does not_ need to behave like BTRFS is.
> 
> It seems that ZFS on linux doesn't support fallocate
> 
> see https://github.com/zfsonlinux/zfs/issues/326
> 
> So I think that you are referring to a posix_fallocate and ZFS on solaris, which I can't test so I can't comment.
Both Solaris, and FreeBSD (I've got a FreeNAS system at work i checked on).

That said, I'm starting to wonder if just failing fallocate() calls to 
allocate space is actually the right thing to do here after all.  Aside 
from this, we don't reserve metadata space for checksums and similar 
things for the eventual writes (so it's possible to get -ENOSPC on a 
write to an fallocate'ed region anyway because of metadata exhaustion), 
and splitting extents can also cause it to fail, so it's perfectly 
possible for the fallocate assumption to not hole on BTRFS.  The irony 
of this is that if you're in a situation where you actually need to 
reserve space, you're more likely to fail (because if you actually 
_need_ to reserve the space, your filesystem may already be mostly full, 
and therefore any of the above issues may occur).

On the specific note of splitting extents, the following will probably 
fail on BTRFS as well when done with a large enough FS (the turn over 
point ends up being the point at which 256MiB isn't enough space to 
account for all the extents), but will succeed with :
1. Create filesystem and mount it.  On BTRFS, make sure autodefrag is 
off (this makes it fail more reliably, but is not essential for it to fail).
2. Use fallocate to allocate as large a file as possible (in the BTRFS 
case, try for the size of the filesystem - 544MiB (512 MiB for the 
metadata chunk, 32 for the system chunk).
3. Write half the file using 1MB blocks and skipping 1MB of space 
between each block (so every other 1MB of space is actually written to.
4. Write the other half of the file by filling in the holes.

The net effect of this is to split the single large fallocat'ed extent 
into a very large number of 1MB extents, which in turn eats up lots of 
metadata space and will eventually exhaust it.  While this specific 
exercise requires a large filesystem, more generic real world situations 
exist where this can happen (and I have had this happen before).
> 
> [...]
>>> In terms of a COW filesystem, you need the space of a) + the space of b)
>> No, that is only required if the entire file needs to be written atomically.  There is some maximal size atomic write that BTRFS can perform as a single operation at a low level (I'm not sure if this is equal to the block size, or larger, but it doesn't matter much, either way, I'm talking the largest chunk of data it will write to a disk in a single operation before updating metadata to point to that new data).
> 
> On the best of my knowledge there is only a time limit: IIRC every 30seconds a transaction is closed. If you are able to fill the filesystem in this time window you are in trouble.
Even with that, it's still possible to implement the method I outlined 
by defining such a limit and forcing a transaction commit when that 
limit is hit.  I'm also not entirely convinced that the transaction is 
the limiting factor here (I was under the impression that the 
transaction just updates the top level metadata to point to the new tree 
of metadata).
