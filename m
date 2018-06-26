Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:55882 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbeFZL4J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 07:56:09 -0400
Received: by mail-it0-f68.google.com with SMTP id 16-v6so1876275itl.5
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 04:56:09 -0700 (PDT)
Subject: Re: btrfs raid10 performance
To: Sterling Windmill <swindmill@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAMOu_z3dhfSVPKFGiZYfDzQx-C-TXRqJ-HJDTm1-DENVYhCwXA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <81879d2b-fcda-15f8-de0a-602cbf4f55de@gmail.com>
Date: Tue, 26 Jun 2018 07:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAMOu_z3dhfSVPKFGiZYfDzQx-C-TXRqJ-HJDTm1-DENVYhCwXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-25 21:05, Sterling Windmill wrote:
> I am running a single btrfs RAID10 volume of eight LUKS devices, each
> using a 2TB SATA hard drive as a backing store. The SATA drives are a
> mixture of Seagate and Western Digital drives, some with RPMs ranging
> from 5400 to 7200. Each seems to individually performance test where I
> would expect for drives of this caliber. They are all attached to an
> LSI PCIe SAS controller and configured in JBOD.
> 
> I have a relatively beefy quad core Xeon CPU that supports AES-NI and
> don't think LUKS is my bottleneck.
> 
> Here's some info from the resulting filesystem:
> 
>    btrfs fi df /storage
>    Data, RAID10: total=6.30TiB, used=6.29TiB
>    System, RAID10: total=8.00MiB, used=560.00KiB
>    Metadata, RAID10: total=9.00GiB, used=7.64GiB
>    GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> In general I see good performance, especially read performance which
> is enough to regularly saturate my gigabit network when copying files
> from this host via samba. Reads are definitely taking advantage of the
> multiple copies of data available and spreading the load among all
> drives.
> 
> Writes aren't quite as rosy, however.
> 
> When writing files using dd like in this example:
> 
>    dd if=/dev/zero of=tempfile bs=1M count=10240 conv=fdatasync,notrun
> c status=progress
> 
> And running a command like:
> 
>    iostat -m 1
> 
> to monitor disk I/O, writes seem to only focus on one of the eight
> disks at a time, moving from one drive to the next. This results in a
> sustained 55-90 MB/sec throughput depending on which disk is being
> written to (remember, some have faster spindle speed than others).
> 
> Am I wrong to expect btrfs' RAID10 mode to write to multiple disks
> simultaneously and to break larger writes into smaller stripes across
> my four pairs of disks?
> 
> I had trouble identifying whether btrfs RAID10 is writing (64K?)
> stripes or (1GB?) blocks to disk in this mode. The latter might make
> more sense based upon what I'm seeing?
> 
> Anything else I should be trying to narrow down the bottleneck?
First, you're probably incorrect that the disk access is being 
parallelized.  Given that BTRFS still doesn't parallelize writes in 
raid1 mode, I very much doubt it does so in raid10 mode.  Parallelizing 
writes is a performance optimization that still hasn't really been 
tackled by anyone.  Realistically, BTRFS writes to exactly one disk at a 
time.  So, in a four disk raid10 array, it first writes to disk 1, waits 
for that to finish, then writes to disk 2, waits for that to finish, 
then 3, waits, and then four.  Overall, this makes writes rather slow.

As far as striping across multiple disks, yes, that does happen.  The 
specifics of this are a bit complicated though, and require explaining a 
bit about how BTRFS works in general.

BTRFS uses a two-stage allocator, first allocating 'large' regions of 
disk space to be used for a specific type of data called chunks, and 
then allocating blocks out of those regions to actually store the data. 
There are three chunk types, data (used for storing actual file 
contents), metadata (used for storing things like filenames, access 
times, directory structure, etc), and system (used to store the 
allocation information for all the other chunks in the filesystem). 
Data chunks are typically 1 GB in size, metadata are typically 256 MB in 
size, and system chunks are highly variable but don't really matter for 
this explanation.  The chunk level is where the actual replication and 
striping happen, and the chunk size represents what is exposed to the 
block allocator (so every 1 GB data chunk exposes 1 GB of space to the 
block allocator).

Now, replicated (raid1 or dup profiles) chunks work just like you would 
expect, each of the two allocations for the chunk is 1 GB, and each byte 
is stored as-is in both.  Striped (raid0 or raid10 profiles) are 
somewhat more complicated, and I actually don't know exactly how they 
end up allocated at the lower level.  However, I do know how the 
striping works.  In short, you can treat each striped set (either a full 
raid0 chunk, or half a raid10 chunk) as being functionally identical in 
operation to a conventional RAID0 array, striping occurs at a small 
block granularity (I think it's equal to the block size, which would be 
4k in most cases), which unfortunately compounds the performance issues 
caused by BTRFS only writing to one disk at a time.

As far as improving the performance, I've got two suggestions for 
alternative storage arrangements:

* If you want to just stick with only BTRFS for storage, try just using 
raid1 mode.  It will give you the same theoretical total capacity as 
raid10 does and will slow down reads somewhat, but should speed up 
writes significantly (because you're only writing to two devices, not 
striping across two sets of four).

* If you're willing to try something a bit different, convert your 
storage array to two LVM or MD RAID0 volumes composed of four devices 
each, and then run BTRFS in raid1 mode on top of those.  This sounds 
stupid, but it actually gets significantly better write performance than 
running BTRFS in raid10 mode, and may get better read performance 
depending on your access patterns.  It also is no more dangerous than 
using BTRFS in raid10 mode.  The only significant disadvantage here is 
that it's somewhat more complicated to reshape the array.

Beyond that, there are some other things you can do that might improve 
performance to a limited degree with your existing arrangement:

* Turn off autodefrag if it's on.  In my limited experience, autodefrag 
is is a serious performance killer when using BTRFS raid10, and you 
realistically shouldn't need it unless you're doing lots of in-place 
partial rewrites of files (not replace by rename like most sane UNIX 
apps do, but actual in-place rewrites).

* Look into using in-line compression in BTRFS.  If you've got a new 
enough kernel and userspace, zstd is the preferred compression method as 
it gets significantly better ratios in most cases than zlib, and is not 
much slower than lzo.  Otherwise, I would suggest lzo.  Assuming your 
CPU and memory are really good compared to your storage devices, this 
can significantly reduce the time it takes to read and write data 
because you're reading and writing less data.  Using `compress-force` 
instead of `compress` is also likely to help here (the names are 
unfortunate, but the first one just tells BTRFS to ignore hints it's 
stored in the inodes that say that a given file won't compress well). 
Note that this probably won't help if you've got nice NVMe storage 
devices, as they're fast enough that the difference in data transfer 
times will be negligible.
