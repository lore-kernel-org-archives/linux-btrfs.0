Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:34773 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758989AbdENQV2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 12:21:28 -0400
Received: by mail-yb0-f180.google.com with SMTP id 132so4626943ybq.1
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 09:21:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de> <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 14 May 2017 10:21:26 -0600
Message-ID: <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 13, 2017 at 3:39 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> When I was doing my ssd research the first time around, the going
> recommendation was to keep 20-33% of the total space on the ssd entirely
> unallocated, allowing it to use that space as an FTL erase-block
> management pool.

Any brand name SSD has its own reserve above its specified size to
ensure that there's decent performance, even when there is no trim
hinting supplied by the OS; and thereby the SSD can only depend on LBA
"overwrites" to know what blocks are to be freed up.


> Anyway, that 20-33% left entirely unallocated/unpartitioned
> recommendation still holds, right?

Not that I'm aware of. I've never done this by literally walling off
space that I won't use. IA fairly large percentage of my partitions
have free space so it does effectively happen as far as the SSD is
concerned. And I use fstrim timer. Most of the file systems support
trim.

Anyway I've stuffed a Samsung 840 EVO to 98% full with an OS/file
system that would not issue trim commands on this drive, and it was
doing full performance writes through that point. Then deleted maybe
5% of the files, and then refill the drive to 98% again, and it was
the same performance.  So it must have had enough in reserve to permit
full performance "overwrites" which were in effect directed to reserve
blocks as the freed up blocks were being erased. Thus the erasure
happening on the fly was not inhibiting performance on this SSD. Now
had I gone to 99.9% full, and then delete say 1GiB, and then started
going a bunch of heavy small file writes rather than sequential? I
don't know what would happening, it might have choked because this is
a lot more work for the SSD to deal with heavy IOPS and erasure.

It will invariably be something that's very model and even firmware
version specific.



>  Am I correct in asserting that if one
> is following that, the FTL already has plenty of erase-blocks available
> for management and the discussion about filesystem level trim and free
> space management becomes much less urgent, tho of course it's still worth
> considering if it's convenient to do so?

Most file systems don't direct writes to new areas, they're fairly
prone to overwriting. So the firmware is going to get notified fairly
quickly with either trim or an overwrite, which LBAs are stale. It's
probably more important with Btrfs which has more variable behavior,
it can continue to direct new writes to recently allocated chunks
before it'll do overwrites in older chunks that have free space.


> And am I also correct in believing that while it's not really worth
> spending more to over-provision to the near 50% as I ended up doing, if
> things work out that way as they did with me because the difference in
> price between 30% overprovisioning and 50% overprovisioning ends up being
> trivial, there's really not much need to worry about active filesystem
> trim at all, because the FTL has effectively half the device left to play
> erase-block musical chairs with as it decides it needs to?


I think it's not worth to overprovision by default ever. Use all of
that space until you have a problem. If you have a 256G drive, you
paid to get the spec performance for 100% of those 256G. You did not
pay that company to second guess things and have cut it slack by
overprovisioning from the outset.

I don't know how long it takes for erasure to happen though, so I have
no idea how much overprovisioning is really needed at the write rate
of the drive, so that it can erase at the same rate as writes, in
order to avoid a slow down.

I guess an even worse test would be one that intentionally fragments
across erase block boundaries, forcing the firmware to be unable to do
erasures without first migrating partially full blocks in order to
make them empty, so they can then be erased, and now be used for new
writes. That sort of shuffling is what will separate the good from
average drives, and why the drives have multicore CPUs on them, as
well as most now having on the fly always on encryption.

Even completely empty, some of these drives have a short term higher
speed write which falls back to a lower speed as the fast flash gets
full. After some pause that fast write capability is restored for
future writes. I have no idea if this is separate kind of flash on the
drive, or if it's just a difference in encoding data onto the flash
that's faster. Samsung has a drive that can "simulate" SLC NAND on 3D
VNAND. That sounds like an encoding method; it's fast but inefficient
and probably needs reencoding.

But that's the thing, the firmware is really complicated now.

I kinda wonder if f2fs could be chopped down to become a modular
allocator for the existing file systems; activate that allocation
method with "ssd" mount option rather than whatever overly smart thing
it does today that's based on assumptions that are now likely
outdated.

-- 
Chris Murphy
