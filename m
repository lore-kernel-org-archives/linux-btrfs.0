Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35810 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755952AbdDRNkQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:40:16 -0400
Received: by mail-io0-f195.google.com with SMTP id d203so30962110iof.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 06:40:15 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8aff196e-0e6b-5252-3011-39b7ff3512f4@gmail.com>
Date: Tue, 18 Apr 2017 09:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-18 09:02, Imran Geriskovan wrote:
> On 4/17/17, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>> Regarding BTRFS specifically:
>> * Given my recently newfound understanding of what the 'ssd' mount
>> option actually does, I'm inclined to recommend that people who are
>> using high-end SSD's _NOT_ use it as it will heavily increase
>> fragmentation and will likely have near zero impact on actual device
>> lifetime (but may _hurt_ performance).  It will still probably help with
>> mid and low-end SSD's.
>
> I'm trying to have a proper understanding of what "fragmentation" really
> means for an ssd and interrelation with wear-leveling.
>
> Before continuing lets remember:
> Pages cannot be erased individually, only whole blocks can be erased.
> The size of a NAND-flash page size can vary, and most drive have pages
> of size 2 KB, 4 KB, 8 KB or 16 KB. Most SSDs have blocks of 128 or 256
> pages, which means that the size of a block can vary between 256 KB
> and 4 MB.
> codecapsule.com/.../coding-for-ssds-part-2-architecture-of-an-ssd-and-benchmarking/
>
> Lets continue:
> Since block sizes are between 256k-4MB, data smaller than this will
> "probably" will not be fragmented in a reasonably empty and trimmed
> drive. And for a brand new ssd we may speak of contiguous series
> of blocks.
We're slightly talking past each other here.  I'm referring to 
fragmentation on the filesystem level.  This impacts performance on 
SSD's because it necessitates a larger number of IO operations to read 
the data off of the device (which is also the case on traditional HDD's, 
but it has near zero impact there compared to the seek latency).  You 
appear to be referring to fragmentation at the level of the 
flash-translation layer (FTL), which is present in almost any SSD, and 
should have near zero impact on performance if the device has good 
firmware and a decent controller.
>
> However, as drive is used more and more and as wear leveling kicking in
> (ie. blocks are remapped) the meaning of "contiguous blocks" will erode.
> So any file bigger than a block size will be written to blocks physically apart
> no matter what their block addresses says. But my guess is that accessing
> device blocks -contiguous or not- are constant time operations. So it would
> not contribute performance issues. Right? Comments?
Correct.
>
> So your the feeling about fragmentation/performance is probably related
> with if the file is spread into less or more blocks. If # of blocks used
> is higher than necessary (ie. no empty blocks can be found. Instead
> lots of partially empty blocks have to be used increasing the total
> # of blocks involved) then we will notice performance loss.
Kind of.

As an example, consider a 16MB file on a device that can read up to 16MB 
of data in a single read operation (arbitrary numbers chose to make math 
easier).

If you copy that file onto the device while it's idle and has a block of 
free space 16MB in size, it will end up as one extent (in BTRFS at 
least, and probably also in most other  extent-based filesystems).  In 
that case, it will take 1 read operation to read the whole file into memory.

If instead that file gets created with multiple extents that aren't 
right next to each other on disk, you will need a number of read 
operation equal to the number of extents to read the file into memory.

The performance loss I'm referring to when talking about fragmentation 
is the result of the increased number of read operations required to 
read a file with a larger number of extents into memory.  It actually 
has nothing to do with whether or not the device is an SSD, a HDD, a 
DVD, NVRAM, SPI NOR flash, an SD card, or any other storage device, it 
just has more impact on storage devices that have zero seek latency 
because the seek latency usually far exceeds the overhead of the extra 
read operations.
>
> Additionally if the filesystem will gonna try something to reduce
> the fragmentation for the blocks, it should precisely know where
> those blocks are located. Then how about ssd block informations?
> Are they available and do filesystems use it?
>
> Anyway if you can provide some more details about your experiences
> on this we can probably have better view on the issue.
>
>
>> * Files with NOCOW and filesystems with 'nodatacow' set will both hurt
>> performance for BTRFS on SSD's, and appear to reduce the lifetime of the
>> SSD.
>
> This and other experinces tell us it is still possible to "forge some
> blocks of ssd". How could this be possible if there is wear-leveling?
>
> Two alternatives comes to mind:
>
> - If there is no empty (trimmed) blocks left on the ssd, it will have no
> chance other than forging the block. How about its reserve blocks?
> Are they exhausted too? Or are they only used as bad block replacements?
>
> - No proper wear-levelling is accually done by the drive.
