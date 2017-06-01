Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36706 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdFASrg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 14:47:36 -0400
Received: by mail-io0-f175.google.com with SMTP id o12so42131562iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 11:47:31 -0700 (PDT)
Subject: Re: understanding differences in recoverability of raid1 vs raid10
 and performance implications of unusual numbers of devices
To: Alexander Peganz <a.peganz@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <11976fb6-3448-b7dc-f067-9482f0505379@gmail.com>
Date: Thu, 1 Jun 2017 14:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-01 10:54, Alexander Peganz wrote:
> Hello,
> 
> I am trying to understand what differences there are in using btrfs
> raid1 vs raid10 in terms of recoverability and also performance.
> This has proven itself to be more difficult than expected since all
> search results I could come up with generally suffer from one of three
> flaws: they either discuss terribly old versions of btrfs, only
> discuss 4 disk settings, or are about traditional HW (or mdadm) RAID
> modes.
> 
>  From what I gathered so far, with raid1 btrfs just puts the 2 copies
> of a file on 2 different devices.
> And raid10 splits files into stripes, then writes 2 copies of each
> stripe to 2 different devices. By splitting the files into stripes it
> can write stripe 1 to devices A and B, while at the same time writing
> stripe 2 to devices C and D, and so on. So a single copy of a file
> might end up split across all devices, as does the second, but with
> the stripes distributed in a way that the copies of each one stripe
> are never on the same device.
Kind of, except for two things:
1. BTRFS doesn't replicate or stripe at the file level.  BTRFS uses a 
two-stage allocator, allocating chunks of disk space for various block 
types, then allocating blocks within those chunks, and the striping and 
replication is done at the chunk level (so how a block is 
replicated/striped is a property of what chunk it is stored in).  Note 
that this is not exactly the same as conventional RAID, which stripe or 
replicate at either the block (RAID 0, 1, 4, 5, 6 and 10) or bit (RAID 2 
and 3) level.  This doesn't have much impact on how it behaves from a 
userspace perspective though unless you're part way through converting 
profiles and you interrupt the conversion, in which case any given file 
_might_ have different replication profiles for different parts.
2. BTRFS will use a number of devices for each stripe in a raid10 setup 
equal to the total number of devices in the array, divided by 2, rounded 
down.  So if you have 4 or 5 devices, each stripe will be across 2 
devices, but if you have 6 or 7, each stripe will be across 3 devices. 
This also happens at the chunk level, so if you have devices of 
different sizes, you may get variable stripe widths depending on how 
many devices have free space when a chunk is allocated.
> 
> So my first question is: is that actually correct? Or does btrfs raid1
> create copies of blocks or something akin to stripes instead of files?
> Because I imagine if it is at the file level there is a difference in
> recoverability if the "wrong" 2 devices die.
> For a raid1 I'd expect to only loose those files whose copies were
> located on those 2 devices. Every file with a copy on one of the still
> working devices would be recoverable. So the more devices there are
> the bigger the percentage of recoverable files could get.
> While with raid10 the copies of every file's first stripe might end up
> on device A and device B, damaging every single file if A and B die at
> the same time.
> This might just be a reason for me to choose raid1 over raid10, so I
> really appreciate if someone could enlighten me ;)
OK, to expound a bit more on this:
* BTRFS raid1 is currently exactly 2 copies.  This is different from LVM 
or MD RAID1, which have a number of replicas equal to the number of 
devices.  This means that if you lose 2 disks from a 3 disk BTRFS raid1 
volume, you will probably lose data, and the filesystem will refuse to 
mount.
* BTRFS raid10 is also exactly 2 copies, but there isn't a consistent 
mapping of devices to strips (segments of stripes), and it's not smart 
enough to fix things properly when you're missing different parts of 
each replica.  This in turn means that just like raid1 mode, if you lose 
2 disks, you've effectively got a dead filesystem.

Given this, the general consensus is that you only use raid10 mode if 
you need the best possible performance (and can't use more complicated 
setups, see the end of my response for suggestions regarding that), and 
use raid1 mode otherwise since it's marginally more reliable and it's 
more likely to allow you to recover entire files from a broken 
filesystem than raid10 mode is.
> 
> As to performance, with raid1 write speed should (theoretically) be
> the same as a single disk (although writing the first half of the data
> to device A while at the same time writing the second half to device B
> would allow to write the first copy in half the time, and would allow
> to create the second copy at some later point in time I highly doubt
> btrfs is quite that adventurous). And read speeds should be up to
> twice that of a single device.
In theory yes, but in practice, this is not the case.  BTRFS currently 
serializes writes (it only writes to one device at a time), and it will 
only service a given read from a single device.  In practice, this means 
that your write speed in raid1 mode is usually half your write speed for 
single device mode with the same hardware, and your read speed is 
identical between the two for any given thread (but by using multiple 
threads, you can improve this to the theoretical double speed).

The same caveats apply to raid10 mode, with the only difference being 
that the serialization is done per-stripe instead of per-device (at 
least, I know it is for reads, I'm not certain for writes), equating to 
at best N/2 write speed and N/2 read speed for a single thread.
> With raid10 write speeds should be N times those of a single disk to
> create the first copy, and since of course a second one has to be
> written as well, effectively up to N/2. Read speeds should be up to N
> times that of a single disk. But I couldn't find useful comparisons
> using more than 4 devices. Should I expect any weirdness if I don't
> have a multiple of 4 devices? Or do I just need an even number of
> devices? Or is everything ok, even odd numbers?
Any number is OK.  BTRFS will intelligently rotate which devices get 
used at the chunk level when it allocates new chunks so that things are 
roughly evenly distributed.  The only important part is that you need a 
minimum of 4 devices for raid10, or 2 for raid1.
> 
> And finally, could using raid10 cause me more headache than raid1
> farther down the line when adding additional devices? How about if
> those devices are not the same size as the original ones, any
> difference between raid1 and 10?
raid1 mode will handle this marginally better than raid10, but you are 
liable to get unexpected behavior when using variably sized devices 
regardless.

Now, if you are willing to use a slightly more complicated setup, you 
can actually get better performance than either option with roughly 
equivalent data safety by using BTRFS in raid1 mode on top of 2 LVM or 
MD RAID0 arrays.  Up until the last few months when I finally finished 
switching everything over to SSD's, this is what I had my systems set up 
for.  It gets you (based on my own testing) roughly 10-40% better 
performance depending on your workload compared to BTRFS raid10 mode, 
and it incurs no penalties in terms of data safety relative to BTRFS 
raid10 mode.  You can also do the same with other RAID levels below 
BTRFS to get varying rations of performance and data safety (I've tested 
it with RAID1, RAID10, and RAID5, all three work well, but are somewhat 
slow).
