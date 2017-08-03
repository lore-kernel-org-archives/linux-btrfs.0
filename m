Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-wd.italiaonline.it ([212.48.13.170]:55853 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751216AbdHCQhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 12:37:52 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Massive loss of disk space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, pwm <pwm@iapetus.neab.net>,
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
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cab4df59-a5ce-9944-22cb-367173dab108@inwind.it>
Date: Thu, 3 Aug 2017 18:37:49 +0200
MIME-Version: 1.0
In-Reply-To: <0abbc952-99d1-8b23-41ee-f58afca11d08@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 13:39, Austin S. Hemmelgarn wrote:
> On 2017-08-02 17:05, Goffredo Baroncelli wrote:
>> On 2017-08-02 21:10, Austin S. Hemmelgarn wrote:
>>> On 2017-08-02 13:52, Goffredo Baroncelli wrote:
>>>> Hi,
>>>>
>> [...]
>>
>>>> consider the following scenario:
>>>>
>>>> a) create a 2GB file
>>>> b) fallocate -o 1GB -l 2GB
>>>> c) write from 1GB to 3GB
>>>>
>>>> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
>>
>>> There is also an expectation based on pretty much every other FS in existence that calling fallocate() on a range that is already in use is a (possibly expensive) no-op, and by extension using fallocate() with an offset of 0 like a ftruncate() call will succeed as long as the new size will fit.
>>
>> The man page of fallocate doesn't guarantee that.
>>
>> Unfortunately in a COW filesystem the assumption that an allocate area may be simply overwritten is not true.
>>
>> Let me to say it with others words: as general rule if you want to _write_ something in a cow filesystem, you need space. Doesn't matter if you are *over-writing* existing data or you are *appending* to a file.
> Yes, you need space, but you don't need _all_ the space.  For a file that already has data in it, you only _need_ as much space as the largest chunk of data that can be written at once at a low level, because the moment that first write finishes, the space that was used in the file for that region is freed, and the next write can go there.  Put a bit differently, you only need to allocate what isn't allocated in the region, and then a bit more to handle the initial write to the file.
> 
> Also, as I said below, _THIS WORKS ON ZFS_.  That immediately means that a CoW filesystem _does not_ need to behave like BTRFS is.

It seems that ZFS on linux doesn't support fallocate

see https://github.com/zfsonlinux/zfs/issues/326

So I think that you are referring to a posix_fallocate and ZFS on solaris, which I can't test so I can't comment.

[...]
>> In terms of a COW filesystem, you need the space of a) + the space of b)
> No, that is only required if the entire file needs to be written atomically.  There is some maximal size atomic write that BTRFS can perform as a single operation at a low level (I'm not sure if this is equal to the block size, or larger, but it doesn't matter much, either way, I'm talking the largest chunk of data it will write to a disk in a single operation before updating metadata to point to that new data). 

On the best of my knowledge there is only a time limit: IIRC every 30seconds a transaction is closed. If you are able to fill the filesystem in this time window you are in trouble.

[...]-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
