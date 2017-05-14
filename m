Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33431 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdENSBI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 14:01:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id y10so23281810wmh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 11:01:07 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Btrfs/SSD
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
Date: Sun, 14 May 2017 19:01:04 +0100
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de>
 <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
 <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All stuff that Chris wrote holds true, I just wanted to add flash specific information (from my experience of writing low level code for operating flash)

So with flash, to erase you have to erase a large allocation block, usually it used to be 128kB (plus some crc data and stuff makes more than 128kB, but we are talking functional data storage space) on never setups it can be megabytes … device dependant really.
To erase a block you need to provide whole 128 x 8 bits with voltage higher that is usually used for IO (can be even 15V) so it requires an external supply or build in internal charge pump to provide that voltage to a block erasure circuitry. This process generates a lot of heat and requires a lot of energy, so consensus back in the day was that you could erase one block at a time and this could take up to 200ms (0.2 second). After a erase you need to check whenever all bits are set to 1 (charged state) and then sector is marked as ready for storage.

Of course, flash memories are moving forward and in more demanding environments there are solutions where blocks are grouped into groups which have separate eraser circuits that will allow errasure to be performed in parallel in multiple parts of flash module, still you are bound to one per group.

Another problem is that erasure procedure locally does increase temperature and on flat flashes it’s not that much of a problem, but on emerging solutions like 3d flashed locally we might experience undesired temperature increases that would either degrade life span of flash or simply erase neighbouring blocks. 

In terms of over provisioning of SSD it’s a give and take relationship … on good drive there is enough over provisioning to allow a normal operation on systems without TRIM … now if you would use a 1TB drive daily without TRIM and have only 30GB stored on it you will have fantastic performance but if you will want to store 500GB at roughly 200GB you will hit a brick wall and you writes will slow dow to megabytes / s … this is symptom of drive running out of over provisioning space … if you would run OS that issues trim, this problem would not exist since drive would know that whole 970GB of space is free and it would be pre-emptively erased days before. 

And last part - hard drive is not aware of filesystem and partitions … so you could have 400GB on this 1TB drive left unpartitioned and still you would be cooked. Technically speaking using as much as possible space on a SSD to a FS and OS that supports trim will give you best performance because drive will be notified of as much as possible disk space that is actually free …..

So, to summaries: 
- don’t try to outsmart built in mechanics of SSD (people that suggest that are just morons that want to have 5 minutes of fame).
- don’t buy crap SSD and expect it to behave like good one if you use below certain % of it … it’s stupid, buy more reasonable SSD but smaller and store slow data on spinning rust.
- read more books and wikipedia, not jumping down on you but internet is filled with people that provide false information, sometimes unknowingly and swear by it ( Dunning–Kruger effect :D ) and some of them are very good and making all theories sexy and stuff … you simply have to get used to it… 
- if something is to good to be true, than it’s not
- promise of future performance gains is a domain of “sleazy salesman"



> On 14 May 2017, at 17:21, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Sat, May 13, 2017 at 3:39 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> When I was doing my ssd research the first time around, the going
>> recommendation was to keep 20-33% of the total space on the ssd entirely
>> unallocated, allowing it to use that space as an FTL erase-block
>> management pool.
> 
> Any brand name SSD has its own reserve above its specified size to
> ensure that there's decent performance, even when there is no trim
> hinting supplied by the OS; and thereby the SSD can only depend on LBA
> "overwrites" to know what blocks are to be freed up.
> 
> 
>> Anyway, that 20-33% left entirely unallocated/unpartitioned
>> recommendation still holds, right?
> 
> Not that I'm aware of. I've never done this by literally walling off
> space that I won't use. IA fairly large percentage of my partitions
> have free space so it does effectively happen as far as the SSD is
> concerned. And I use fstrim timer. Most of the file systems support
> trim.
> 
> Anyway I've stuffed a Samsung 840 EVO to 98% full with an OS/file
> system that would not issue trim commands on this drive, and it was
> doing full performance writes through that point. Then deleted maybe
> 5% of the files, and then refill the drive to 98% again, and it was
> the same performance.  So it must have had enough in reserve to permit
> full performance "overwrites" which were in effect directed to reserve
> blocks as the freed up blocks were being erased. Thus the erasure
> happening on the fly was not inhibiting performance on this SSD. Now
> had I gone to 99.9% full, and then delete say 1GiB, and then started
> going a bunch of heavy small file writes rather than sequential? I
> don't know what would happening, it might have choked because this is
> a lot more work for the SSD to deal with heavy IOPS and erasure.
> 
> It will invariably be something that's very model and even firmware
> version specific.
> 
> 
> 
>> Am I correct in asserting that if one
>> is following that, the FTL already has plenty of erase-blocks available
>> for management and the discussion about filesystem level trim and free
>> space management becomes much less urgent, tho of course it's still worth
>> considering if it's convenient to do so?
> 
> Most file systems don't direct writes to new areas, they're fairly
> prone to overwriting. So the firmware is going to get notified fairly
> quickly with either trim or an overwrite, which LBAs are stale. It's
> probably more important with Btrfs which has more variable behavior,
> it can continue to direct new writes to recently allocated chunks
> before it'll do overwrites in older chunks that have free space.
> 
> 
>> And am I also correct in believing that while it's not really worth
>> spending more to over-provision to the near 50% as I ended up doing, if
>> things work out that way as they did with me because the difference in
>> price between 30% overprovisioning and 50% overprovisioning ends up being
>> trivial, there's really not much need to worry about active filesystem
>> trim at all, because the FTL has effectively half the device left to play
>> erase-block musical chairs with as it decides it needs to?
> 
> 
> I think it's not worth to overprovision by default ever. Use all of
> that space until you have a problem. If you have a 256G drive, you
> paid to get the spec performance for 100% of those 256G. You did not
> pay that company to second guess things and have cut it slack by
> overprovisioning from the outset.
> 
> I don't know how long it takes for erasure to happen though, so I have
> no idea how much overprovisioning is really needed at the write rate
> of the drive, so that it can erase at the same rate as writes, in
> order to avoid a slow down.
> 
> I guess an even worse test would be one that intentionally fragments
> across erase block boundaries, forcing the firmware to be unable to do
> erasures without first migrating partially full blocks in order to
> make them empty, so they can then be erased, and now be used for new
> writes. That sort of shuffling is what will separate the good from
> average drives, and why the drives have multicore CPUs on them, as
> well as most now having on the fly always on encryption.
> 
> Even completely empty, some of these drives have a short term higher
> speed write which falls back to a lower speed as the fast flash gets
> full. After some pause that fast write capability is restored for
> future writes. I have no idea if this is separate kind of flash on the
> drive, or if it's just a difference in encoding data onto the flash
> that's faster. Samsung has a drive that can "simulate" SLC NAND on 3D
> VNAND. That sounds like an encoding method; it's fast but inefficient
> and probably needs reencoding.
> 
> But that's the thing, the firmware is really complicated now.
> 
> I kinda wonder if f2fs could be chopped down to become a modular
> allocator for the existing file systems; activate that allocation
> method with "ssd" mount option rather than whatever overly smart thing
> it does today that's based on assumptions that are now likely
> outdated.
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

