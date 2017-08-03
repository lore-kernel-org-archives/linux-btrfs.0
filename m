Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35484 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdHCLjs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 07:39:48 -0400
Received: by mail-io0-f170.google.com with SMTP id m88so5853496iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 04:39:48 -0700 (PDT)
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0abbc952-99d1-8b23-41ee-f58afca11d08@gmail.com>
Date: Thu, 3 Aug 2017 07:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <f227b82c-171a-4475-e08c-6abb53de51f2@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-02 17:05, Goffredo Baroncelli wrote:
> On 2017-08-02 21:10, Austin S. Hemmelgarn wrote:
>> On 2017-08-02 13:52, Goffredo Baroncelli wrote:
>>> Hi,
>>>
> [...]
> 
>>> consider the following scenario:
>>>
>>> a) create a 2GB file
>>> b) fallocate -o 1GB -l 2GB
>>> c) write from 1GB to 3GB
>>>
>>> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
> 
>> There is also an expectation based on pretty much every other FS in existence that calling fallocate() on a range that is already in use is a (possibly expensive) no-op, and by extension using fallocate() with an offset of 0 like a ftruncate() call will succeed as long as the new size will fit.
> 
> The man page of fallocate doesn't guarantee that.
> 
> Unfortunately in a COW filesystem the assumption that an allocate area may be simply overwritten is not true.
> 
> Let me to say it with others words: as general rule if you want to _write_ something in a cow filesystem, you need space. Doesn't matter if you are *over-writing* existing data or you are *appending* to a file.
Yes, you need space, but you don't need _all_ the space.  For a file 
that already has data in it, you only _need_ as much space as the 
largest chunk of data that can be written at once at a low level, 
because the moment that first write finishes, the space that was used in 
the file for that region is freed, and the next write can go there.  Put 
a bit differently, you only need to allocate what isn't allocated in the 
region, and then a bit more to handle the initial write to the file.

Also, as I said below, _THIS WORKS ON ZFS_.  That immediately means that 
a CoW filesystem _does not_ need to behave like BTRFS is.
> 
> 
>>
>> I've checked JFS, XFS, ext4, vfat, NTFS (via NTFS-3G, not the kernel driver), NILFS2, OCFS2 (local mode only), F2FS, UFS, and HFS+ on Linux, UFS and HFS+ on OS X, UFS and ZFS on FreeBSD, FFS (UFS with a different name) and LFS (log structured) on NetBSD, and UFS and ZFS on Solaris, and VxFS on HP-UX, and _all_ of them behave correctly here and succeed with the test I listed, while BTRFS does not.  This isn't codified in POSIX, but it's also not something that is listed as implementation defined, which in turn means that we should be trying to match the other implementations.
> 
> [...]
> 
>>
>>>
>>> My opinion is that in general this behavior is correct due to the COW nature of BTRFS.
>>> The only exception that I can find, is about the "nocow" file. For these cases taking in accout the already allocated space would be better.
>> There are other, saner ways to make that expectation hold though, and I'm not even certain that it does as things are implemented (I believe we still CoW unwritten extents when data is written to them, because I _have_ had writes to fallocate'ed files fail on BTRFS before with -ENOSPC).
>>
>> The ideal situation IMO is as follows:
>>
>> 1. This particular case (using fallocate() with an offset of 0 to extend a file that is already larger than half the remaining free space on the FS) _should_ succeed.
> 
> This description is not accurate. What happened is the following:
> 1) you have a file *with valid data*
> 2) you want to prepare an update of this file and want to be sure to have enough space
Except this is not the common case.  Most filesystems aren't CoW, so 
calling fallocate() like this is generally not 'ensuring you have enough 
space', it's 'ensuring the file isn't sparse, and we can write to the 
extra area beyond the end we care about'.
> 
> at this point fallocate have to guarantee:
> a) you have your old data still available
> b) you have allocated the space for the update
> 
> In terms of a COW filesystem, you need the space of a) + the space of b)
No, that is only required if the entire file needs to be written 
atomically.  There is some maximal size atomic write that BTRFS can 
perform as a single operation at a low level (I'm not sure if this is 
equal to the block size, or larger, but it doesn't matter much, either 
way, I'm talking the largest chunk of data it will write to a disk in a 
single operation before updating metadata to point to that new data). 
If your total size (original data plus the new space) is less than this 
maximal atomic write size, then the above is true, but if it is larger, 
you only need to allocate space for regions of the fallocate() range 
that aren't already allocated, plus space to accommodate at least one 
write of this maximal atomic write size.  Any space beyond that just 
ends up minimizing the degree of fragmentation introduced by allocation.

The methodology that allows this is really simple.  When you start to 
write data to the file, the first part of the write goes into the newly 
allocated space, and the original region covered by that write gets 
freed.  You can then write into the space that was just freed and repeat 
the process until the write is done.  Implementing this requires the 
freeing process to know that the freed region was covered by an 
fallocate() call, and thus that it should be saved for future writes. 
Provided that the back-conversion from used space to fallocated() space 
is done directly, this is also race free.
> 
> 
>> Short of very convoluted configurations, extending a file with fallocate will not result in over-committing space on a CoW filesystem unless it would extend the file by more than the remaining free space, and therefore barring long external interactions, subsequent writes will also succeed.  Proof of this for a general case is somewhat complicated, but in the very specific case of the script I posted as a reproducer in the other thread about this and the test case I gave in this thread, it's trivial to prove that the writes will succeed.  Either way, the behavior of SnapRAID, while not optimal in this case, is still a legitimate usage (I've seen programs do things like that just to make sure the file isn't sparse).
>>
>> 2. Conversion of unwritten extents to written ones should not require new allocation.  Ideally, we need to be allocating not just space for the data, but also reasonable space for the associated metadata when allocating an unwritten extent, and there should be no CoW involved when they are written to except for the small metadata updates required to account the new blocks.  Unless we're doing this, then we have edge cases where the the above listed expectation does not hold (also note that GlobalReserve does not count IMO, it's supposed to be for temporary usage only and doesn't ever appear to be particularly large).
>>
>> 3. There should be some small amount of space reserved globally for not just metadata, but data too, so that a 'full' filesystem can still update existing files reliably.  I'm not sure that we're not doing this already, but AIUI, GlobalReserve is metadata only.  If we do this, we don't have to worry _as much_ about avoiding CoW when converting unwritten extents to regular ones.
>>>
>>> Comments are welcome.
>>>
>>> BR
>>> G.Baroncelli
>>>
>>> [1] from man 2 fallocate
>>> [...]
>>>          After  a  successful call, subsequent writes into the range specified by offset and len are
>>>          guaranteed not to fail because of lack of disk space.
>>> [...]
>>>
>>>
>>> [2]
>>>
>>> -- create a 5G btrfs filesystem
>>>
>>> # mkdir t1
>>> # truncate --size 5G disk
>>> # losetup /dev/loop0 disk
>>> # mkfs.btrfs /dev/loop0
>>> # mount /dev/loop0 t1
>>>
>>> -- test
>>> -- create a 1500 MB file, the expand it to 4000MB
>>> -- expected result: the file is 4000MB size
>>> -- result: fail: the expansion fails
>>>
>>> # fallocate -l $((1024*1024*100*15))  file.bin
>>> # fallocate -l $((1024*1024*100*40))  file.bin
>>> fallocate: fallocate failed: No space left on device
>>> # ls -lh file.bin
>>> -rw-r--r-- 1 root root 1.5G Aug  2 19:09 file.bin
>>>
>>>
>>
>>
> 
> 

