Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35482 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932931AbdBHJOu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 04:14:50 -0500
Received: by mail-wr0-f173.google.com with SMTP id 89so56698976wrr.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 01:14:49 -0800 (PST)
Subject: Re: dup vs raid1 in single disk
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
 <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
 <20170119232340.64327c09@natsu>
 <6f06bd6b-67c9-533b-9bf5-89cff8b892da@gmail.com>
 <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
From: "Alejandro R. Mosteo" <mosteo@gmail.com>
Message-ID: <1dfeb4e4-cccc-4780-6164-49e8cf68ebd6@gmail.com>
Date: Wed, 8 Feb 2017 10:14:46 +0100
MIME-Version: 1.0
In-Reply-To: <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/17 23:28, Kai Krakow wrote:
> To be realistic: I wouldn't trade space usage for duplicate data on an
> already failing disk, no matter if it's DUP or RAID1. HDD disk space is
> cheap, and using such a scenario is just waste of performance AND
> space - no matter what. I don't understand the purpose of this. It just
> results in fake safety.
The disk is already replaced and no longer my workstation main drive. I 
work with large datasets in my research, and I don't care much about 
sustained I/O efficiency, since they're only read when needed. Hence, is 
a matter of juicing out the last life of that disk, instead of 
discarding it right away. This way I can have one extra local storage 
that may spare me the copy from a remote, so I prefer to play with it 
until it dies. Besides, it affords me a chance to play with btrfs/zfs in 
ways that I wouldn't normally risk, and I can also assess their behavior 
with a truly failing disk.

In the end, after a destructive write pass with badblocks, the disk 
increasing uncorrectable sectors have disappeared... go figure. So right 
now I have a btrfs filesystem built with single profile on top of four 
differently sized partitions. When/if bad blocks reappear I'll test some 
raid configuration; probably raidz unless btrfs raid5 is somewhat usable 
by then (why go with half a disk worth when you can have 2/3? ;-))

Thanks for your justified concern though.

Alex.

> Better get two separate devices half the size. There's a better chance
> of getting a better cost/space ratio anyways, plus better performance
> and safety.
>
>> There's also the fact that you're writing more metadata than data
>> most of the time unless you're dealing with really big files, and
>> metadata is already DUP mode (unless you are using an SSD), so the
>> performance hit isn't 50%, it's actually a bit more than half the
>> ratio of data writes to metadata writes.
>>>   
>>>> On a related note, I see this caveat about dup in the manpage:
>>>>
>>>> "For example, a SSD drive can remap the blocks internally to a
>>>> single copy thus deduplicating them. This negates the purpose of
>>>> increased redunancy (sic) and just wastes space"
>>> That ability is vastly overestimated in the man page. There is no
>>> miracle content-addressable storage system working at 500 MB/sec
>>> speeds all within a little cheap controller on SSDs. Likely most of
>>> what it can do, is just compress simple stuff, such as runs of
>>> zeroes or other repeating byte sequences.
>> Most of those that do in-line compression don't implement it in
>> firmware, they implement it in hardware, and even DEFLATE can get 500
>> MB/second speeds if properly implemented in hardware.  The firmware
>> may control how the hardware works, but it's usually hardware doing
>> heavy lifting in that case, and getting a good ASIC made that can hit
>> the required performance point for a reasonable compression algorithm
>> like LZ4 or Snappy is insanely cheap once you've gotten past the VLSI
>> work.
> I still thinks it's a myth... The overhead of managing inline
> deduplication is just way too high to implement it without jumping
> through expensive hoops. Most workloads have almost zero deduplication
> potential. And even when, their temporal occurrence is spaced so far
> that an inline deduplicator won't catch it.
>
> If it would be all so easy, btrfs would already have it working in
> mainline. I don't even remember that those patches is still being
> worked on.
>
> With this in mind, I think dup metadata is still a good think to have
> even on SSD and I would always force to enable it.
>
> Potential for deduplication is only when using snapshots (which already
> are deduplicated when taken) or when handling user data on a file
> server in a multi-user environment. Users tend to copy their files all
> over the place - multiple directories of multiple gigabytes. Potential
> is also where you're working with client machine backups or vm images.
> I regularly see deduplication efficiency of 30-60% in such scenarios -
> file servers mostly which I'm handling. But due to temporally far
> spaced occurrence of duplicate blocks, only offline or nearline
> deduplication works here.
>
>>> And the DUP mode is still useful on SSDs, for cases when one copy
>>> of the DUP gets corrupted in-flight due to a bad controller or RAM
>>> or cable, you could then restore that block from its good-CRC DUP
>>> copy.
>> The only window of time during which bad RAM could result in only one
>> copy of a block being bad is after the first copy is written but
>> before the second is, which is usually an insanely small amount of
>> time.  As far as the cabling, the window for errors resulting in a
>> single bad copy of a block is pretty much the same as for RAM, and if
>> they're persistently bad, you're more likely to lose data for other
>> reasons.
> It depends on the design of the software. You're true if this memory
> block is simply a single block throughout its lifetime in RAM before
> written to storage. But if it is already handled as duplicate block in
> memory, odds are different. I hope btrfs is doing this right... ;-)
>
>> That said, I do still feel that DUP mode has value on SSD's.  The
>> primary arguments against it are:
>> 1. It wears out the SSD faster.
> I don't think this is a huge factor, even more when looking at TBW
> capabilities of modern SSDs. And prices are low enough to better swap
> early than waiting for the disaster hitting you. Instead, you can still
> use the old SSD for archival storage (but this has drawbacks, don't
> leave them without power for months or years!) or as a shock resistent
> USB mobile drive on the go.
>
>> 2. The blocks are likely to end up in the same erase block, and
>> therefore there will be no benefit.
> Oh, this is probably a point to really think about... Would ssd_spread
> help here?
>
>> The first argument is accurate, but not usually an issue for most
>> people.  Average life expectancy for a decent SSD is well over 10
>> years, which is more than twice the usual life expectancy for a
>> consumer hard drive.
> Well, my first SSD (128 GB) was worn (according to SMART) after only 12
> months. Bigger drives wear much slower. I now have a 500 GB SSD and
> looking at SMART it projects to serve me well for the next 3-4 years
> or longer. But it will be worn out then. But I'm pretty sure I'll get a
> new drive until then - for performance and space reasons. My high usage
> pattern probably results from using the drives for bcache in write-back
> mode. Btrfs as the bcache user does it's own job (because of CoW) of
> pressing much more data through bcache than normal expectations.
>
>> As far as the second argument against it, that one is partially
>> correct, but ignores an important factor that many people who don't
>> do hardware design (and some who do) don't often consider.  The close
>> temporal proximity of the writes for each copy are likely to mean
>> they end up in the same erase block on the SSD (especially if the SSD
>> has a large write cache).
> Deja vu...
>
>>   However, that doesn't mean that one
>> getting corrupted due to device failure is guaranteed to corrupt the
>> other.  The reason for this is exactly the same reason that single
>> word errors in RAM are exponentially more common than losing a whole
>> chip or the whole memory module: The primary error source is
>> environmental noise (EMI, cosmic rays, quantum interference,
>> background radiation, etc), not system failure.  In other words,
>> you're far more likely to lose a single cell (which is usually not
>> more than a single byte in the MLC flash that gets used in most
>> modern SSD's) in the erase block than the whole erase block.  In that
>> event, you obviously have only got corruption in the particular
>> filesystem block that that particular cell was storing data for.
> Sounds reasonable...
>
>> There's also a third argument for not using DUP on SSD's however:
>> The SSD already does most of the data integrity work itself.
> DUP is really not for integrity but for consistency. If one copy of the
> block becomes damaged for perfectly reasonable instructions sent by the
> OS (from the drive firmware perspective), that block has perfect data
> integrity. But if it was the single copy of a metadata block, your FS
> is probably toast now. In DUP mode you still have the other copy for
> consistent filesystem structures. With this copy, the OS can now restore
> filesystem integrity (which is levels above block level integrity).
>
>

