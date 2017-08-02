Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:32789 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdHBTKl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 15:10:41 -0400
Received: by mail-io0-f179.google.com with SMTP id j32so24164257iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 12:10:41 -0700 (PDT)
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6dc6ca6a-7f55-4176-e2b7-ae8ab69eca00@gmail.com>
Date: Wed, 2 Aug 2017 15:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-02 13:52, Goffredo Baroncelli wrote:
> Hi,
> 
> On 2017-08-01 17:00, Austin S. Hemmelgarn wrote:
>> OK, I just did a dead simple test by hand, and it looks like I was right.  The method I used to check this is as follows:
>> 1. Create and mount a reasonably small filesystem (I used an 8G temporary LV for this, a file would work too though).
>> 2. Using dd or a similar tool, create a test file that takes up half of the size of the filesystem.  It is important that this _not_ be fallocated, but just written out.
>> 3. Use `fallocate -l` to try and extend the size of the file beyond half the size of the filesystem.
>>
>> For BTRFS, this will result in -ENOSPC, while for ext4 and XFS, it will succeed with no error.  Based on this and some low-level inspection, it looks like BTRFS treats the full range of the fallocate call as unallocated, and thus is trying to allocate space for regions of that range that are already allocated.
> 
> I can confirm this behavior; below some step to reproduce it [2]; however I don't think that it is a bug, but this is the correct behavior for a COW filesystem (see below).
> 
> 
> Looking at the function btrfs_fallocate() (file fs/btrfs/file.c)
> 
> 
> static long btrfs_fallocate(struct file *file, int mode,
>                              loff_t offset, loff_t len)
> {
> [...]
>          alloc_start = round_down(offset, blocksize);
>          alloc_end = round_up(offset + len, blocksize);
> [...]
>          /*
>           * Only trigger disk allocation, don't trigger qgroup reserve
>           *
>           * For qgroup space, it will be checked later.
>           */
>          ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode),
>                          alloc_end - alloc_start)
> 
> 
> it seems that BTRFS always allocate the maximum space required, without consider the one already allocated. Is it too conservative ? I think no: consider the following scenario:
> 
> a) create a 2GB file
> b) fallocate -o 1GB -l 2GB
> c) write from 1GB to 3GB
> 
> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
There is also an expectation based on pretty much every other FS in 
existence that calling fallocate() on a range that is already in use is 
a (possibly expensive) no-op, and by extension using fallocate() with an 
offset of 0 like a ftruncate() call will succeed as long as the new size 
will fit.

I've checked JFS, XFS, ext4, vfat, NTFS (via NTFS-3G, not the kernel 
driver), NILFS2, OCFS2 (local mode only), F2FS, UFS, and HFS+ on Linux, 
UFS and HFS+ on OS X, UFS and ZFS on FreeBSD, FFS (UFS with a different 
name) and LFS (log structured) on NetBSD, and UFS and ZFS on Solaris, 
and VxFS on HP-UX, and _all_ of them behave correctly here and succeed 
with the test I listed, while BTRFS does not.  This isn't codified in 
POSIX, but it's also not something that is listed as implementation 
defined, which in turn means that we should be trying to match the other 
implementations.

> 
> My opinion is that in general this behavior is correct due to the COW nature of BTRFS.
> The only exception that I can find, is about the "nocow" file. For these cases taking in accout the already allocated space would be better.
There are other, saner ways to make that expectation hold though, and 
I'm not even certain that it does as things are implemented (I believe 
we still CoW unwritten extents when data is written to them, because I 
_have_ had writes to fallocate'ed files fail on BTRFS before with -ENOSPC).

The ideal situation IMO is as follows:

1. This particular case (using fallocate() with an offset of 0 to extend 
a file that is already larger than half the remaining free space on the 
FS) _should_ succeed.  Short of very convoluted configurations, 
extending a file with fallocate will not result in over-committing space 
on a CoW filesystem unless it would extend the file by more than the 
remaining free space, and therefore barring long external interactions, 
subsequent writes will also succeed.  Proof of this for a general case 
is somewhat complicated, but in the very specific case of the script I 
posted as a reproducer in the other thread about this and the test case 
I gave in this thread, it's trivial to prove that the writes will 
succeed.  Either way, the behavior of SnapRAID, while not optimal in 
this case, is still a legitimate usage (I've seen programs do things 
like that just to make sure the file isn't sparse).

2. Conversion of unwritten extents to written ones should not require 
new allocation.  Ideally, we need to be allocating not just space for 
the data, but also reasonable space for the associated metadata when 
allocating an unwritten extent, and there should be no CoW involved when 
they are written to except for the small metadata updates required to 
account the new blocks.  Unless we're doing this, then we have edge 
cases where the the above listed expectation does not hold (also note 
that GlobalReserve does not count IMO, it's supposed to be for temporary 
usage only and doesn't ever appear to be particularly large).

3. There should be some small amount of space reserved globally for not 
just metadata, but data too, so that a 'full' filesystem can still 
update existing files reliably.  I'm not sure that we're not doing this 
already, but AIUI, GlobalReserve is metadata only.  If we do this, we 
don't have to worry _as much_ about avoiding CoW when converting 
unwritten extents to regular ones.
> 
> Comments are welcome.
> 
> BR
> G.Baroncelli
> 
> [1] from man 2 fallocate
> [...]
>         After  a  successful call, subsequent writes into the range specified by offset and len are
>         guaranteed not to fail because of lack of disk space.
> [...]
> 
> 
> [2]
> 
> -- create a 5G btrfs filesystem
> 
> # mkdir t1
> # truncate --size 5G disk
> # losetup /dev/loop0 disk
> # mkfs.btrfs /dev/loop0
> # mount /dev/loop0 t1
> 
> -- test
> -- create a 1500 MB file, the expand it to 4000MB
> -- expected result: the file is 4000MB size
> -- result: fail: the expansion fails
> 
> # fallocate -l $((1024*1024*100*15))  file.bin
> # fallocate -l $((1024*1024*100*40))  file.bin
> fallocate: fallocate failed: No space left on device
> # ls -lh file.bin
> -rw-r--r-- 1 root root 1.5G Aug  2 19:09 file.bin
> 
> 

