Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33661 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAUQA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jan 2017 11:00:58 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so14383690wme.0
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jan 2017 08:00:57 -0800 (PST)
Received: from [192.168.2.69] (196.233.15.37.dynamic.jazztel.es. [37.15.233.196])
        by smtp.gmail.com with ESMTPSA id 10sm5044694wrw.13.2017.01.21.08.00.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Jan 2017 08:00:55 -0800 (PST)
From: "Alejandro R. Mosteo" <psalleetsile@gmail.com>
Subject: Re: dup vs raid1 in single disk
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
 <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
 <20170119232340.64327c09@natsu>
 <6f06bd6b-67c9-533b-9bf5-89cff8b892da@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <def0937e-28dd-19b6-e7f6-78b955288ab7@mosteo.com>
Date: Sat, 21 Jan 2017 17:00:54 +0100
MIME-Version: 1.0
In-Reply-To: <6f06bd6b-67c9-533b-9bf5-89cff8b892da@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Austin and Roman for the interesting discussion.

Alex.

On 19/01/17 21:02, Austin S. Hemmelgarn wrote:
> On 2017-01-19 13:23, Roman Mamedov wrote:
>> On Thu, 19 Jan 2017 17:39:37 +0100
>> "Alejandro R. Mosteo" <alejandro@mosteo.com> wrote:
>>
>>> I was wondering, from a point of view of data safety, if there is any
>>> difference between using dup or making a raid1 from two partitions in
>>> the same disk. This is thinking on having some protection against the
>>> typical aging HDD that starts to have bad sectors.
>>
>> RAID1 will write slower compared to DUP, as any optimization to make 
>> RAID1
>> devices work in parallel will cause a total performance disaster for 
>> you as
>> you will start trying to write to both partitions at the same time, 
>> turning
>> all linear writes into random ones, which are about two orders of 
>> magnitude
>> slower than linear on spinning hard drives. DUP shouldn't have this 
>> issue, but
>> still it will be twice slower than single, since you are writing 
>> everything
>> twice.
> As of right now, there will actually be near zero impact on write 
> performance (or at least, it's way less than the theoretical 50%) 
> because there really isn't any optimization to speak of in the 
> multi-device code.  That will hopefully change over time, but it's not 
> likely to do so any time in the future since nobody appears to be 
> working on multi-device write performance.
>>
>> You could consider DUP data for when a disk is already known to be 
>> getting bad
>> sectors from time to time -- but then it's a fringe exercise to try 
>> and keep
>> using such disk in the first place. Yeah with DUP data DUP metadata 
>> you can
>> likely have some more life out of such disk as a throwaway storage 
>> space for
>> non-essential data, at half capacity, but is it worth the effort, as 
>> it's
>> likely to start failing progressively worse over time.
>>
>> In all other cases the performance and storage space penalty of DUP 
>> within a
>> single device are way too great (and gained redundancy is too low) 
>> compared
>> to a proper system of single profile data + backups, or a RAID5/6 
>> system (not
>> Btrfs-based) + backups.
> That really depends on your usage.  In my case, I run DUP data on 
> single disks regularly.  I still do backups of course, but the 
> performance is worth far less for me (especially in the cases where 
> I'm using NVMe SSD's which have performance measured in thousands of 
> MB/s for both reads and writes) than the ability to recover from 
> transient data corruption without needing to go to a backup.
>
> As long as /home and any other write heavy directories are on a 
> separate partition, I would actually advocate using DUP data on your 
> root filesystem if you can afford the space simply because it's a 
> whole lot easier to recover other data if the root filesystem still 
> works.  Most of the root filesystem except some stuff under /var 
> follows a WORM access pattern, and even the stuff that doesn't in /var 
> is usually not performance critical, so the write performance penalty 
> won't have anywhere near as much impact on how well the system runs as 
> you might think.
>
> There's also the fact that you're writing more metadata than data most 
> of the time unless you're dealing with really big files, and metadata 
> is already DUP mode (unless you are using an SSD), so the performance 
> hit isn't 50%, it's actually a bit more than half the ratio of data 
> writes to metadata writes.
>>
>>> On a related note, I see this caveat about dup in the manpage:
>>>
>>> "For example, a SSD drive can remap the blocks internally to a single
>>> copy thus deduplicating them. This negates the purpose of increased
>>> redunancy (sic) and just wastes space"
>>
>> That ability is vastly overestimated in the man page. There is no 
>> miracle
>> content-addressable storage system working at 500 MB/sec speeds all 
>> within a
>> little cheap controller on SSDs. Likely most of what it can do, is just
>> compress simple stuff, such as runs of zeroes or other repeating byte
>> sequences.
> Most of those that do in-line compression don't implement it in 
> firmware, they implement it in hardware, and even DEFLATE can get 500 
> MB/second speeds if properly implemented in hardware.  The firmware 
> may control how the hardware works, but it's usually hardware doing 
> heavy lifting in that case, and getting a good ASIC made that can hit 
> the required performance point for a reasonable compression algorithm 
> like LZ4 or Snappy is insanely cheap once you've gotten past the VLSI 
> work.
>>
>> And the DUP mode is still useful on SSDs, for cases when one copy of 
>> the DUP
>> gets corrupted in-flight due to a bad controller or RAM or cable, you 
>> could
>> then restore that block from its good-CRC DUP copy.
> The only window of time during which bad RAM could result in only one 
> copy of a block being bad is after the first copy is written but 
> before the second is, which is usually an insanely small amount of 
> time.  As far as the cabling, the window for errors resulting in a 
> single bad copy of a block is pretty much the same as for RAM, and if 
> they're persistently bad, you're more likely to lose data for other 
> reasons.
>
> That said, I do still feel that DUP mode has value on SSD's.  The 
> primary arguments against it are:
> 1. It wears out the SSD faster.
> 2. The blocks are likely to end up in the same erase block, and 
> therefore there will be no benefit.
>
> The first argument is accurate, but not usually an issue for most 
> people.  Average life expectancy for a decent SSD is well over 10 
> years, which is more than twice the usual life expectancy for a 
> consumer hard drive.  Putting it in further perspective, the 575GB 
> SSD's have been running essentially 24/7 for the past year and a half 
> (13112 hours powered on now), and have seen just short of 25.7TB of 
> writes over that time.  This equates to roughly 2GB/hour, which is 
> well within typical desktop usage.  It also means they've seen more 
> than 44.5 times their total capacity in writes.  Despite this, the 
> wear-out indicators all show that I can still expect at least 9 years 
> more of run-time on these.  Normalizing that, that means I'm likely to 
> see between 8 and 12 years of life on these.  Equivalent stats for the 
> HDD's I used to use (NAS rated Seagate drives) gave me a roughly 3-5 
> year life expectancy, less than half that of the SSD.  In both cases 
> however, you're talking well beyond the typical life expectancy of 
> anything short of a server or a tight-embedded system, and worrying 
> about a 4-year versus 8-year life expectancy on your storage device is 
> kind of pointless when you need to upgrade the rest of the system in 3 
> years.
>
> As far as the second argument against it, that one is partially 
> correct, but ignores an important factor that many people who don't do 
> hardware design (and some who do) don't often consider. The close 
> temporal proximity of the writes for each copy are likely to mean they 
> end up in the same erase block on the SSD (especially if the SSD has a 
> large write cache).  However, that doesn't mean that one getting 
> corrupted due to device failure is guaranteed to corrupt the other.  
> The reason for this is exactly the same reason that single word errors 
> in RAM are exponentially more common than losing a whole chip or the 
> whole memory module: The primary error source is environmental noise 
> (EMI, cosmic rays, quantum interference, background radiation, etc), 
> not system failure.  In other words, you're far more likely to lose a 
> single cell (which is usually not more than a single byte in the MLC 
> flash that gets used in most modern SSD's) in the erase block than the 
> whole erase block.  In that event, you obviously have only got 
> corruption in the particular filesystem block that that particular 
> cell was storing data for.
>
> There's also a third argument for not using DUP on SSD's however:
> The SSD already does most of the data integrity work itself.
> This is only true of good SSD's, but many do have some degree of 
> built-in erasure coding in the firmware which can handle losing large 
> chunks of an erase block and still return the data safely. This is 
> part of the reason that you almost never see nice power-of-two sizes 
> for flash Storage despite flash chips being made that way them,selves 
> (the other part is the spare blocks). Depending on the degree of 
> protection provided by this erasure coding, it can actually cancel out 
> my argument against argument 2.  In all practicality though, that 
> requires you to actually trust the SSD manufacturer to have 
> implemented things properly for it to be a valid counter-argument, and 
> most people who would care enough about data integrity to use BTRFS 
> for that reason are not likely to trust the storage device that much.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

