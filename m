Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35419 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756816AbdEOLqG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 07:46:06 -0400
Received: by mail-it0-f48.google.com with SMTP id c15so41067378ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 04:46:06 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id h76sm5186582ith.24.2017.05.15.04.46.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 May 2017 04:46:04 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5473fbb0-76b4-febe-92c4-67fe35ed5aa1@gmail.com>
Date: Mon, 15 May 2017 07:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <20170512202756.16bd785f@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-12 14:27, Kai Krakow wrote:
> Am Tue, 18 Apr 2017 15:02:42 +0200
> schrieb Imran Geriskovan <imran.geriskovan@gmail.com>:
>
>> On 4/17/17, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>>> Regarding BTRFS specifically:
>>> * Given my recently newfound understanding of what the 'ssd' mount
>>> option actually does, I'm inclined to recommend that people who are
>>> using high-end SSD's _NOT_ use it as it will heavily increase
>>> fragmentation and will likely have near zero impact on actual device
>>> lifetime (but may _hurt_ performance).  It will still probably help
>>> with mid and low-end SSD's.
>>
>> I'm trying to have a proper understanding of what "fragmentation"
>> really means for an ssd and interrelation with wear-leveling.
>>
>> Before continuing lets remember:
>> Pages cannot be erased individually, only whole blocks can be erased.
>> The size of a NAND-flash page size can vary, and most drive have pages
>> of size 2 KB, 4 KB, 8 KB or 16 KB. Most SSDs have blocks of 128 or 256
>> pages, which means that the size of a block can vary between 256 KB
>> and 4 MB.
>> codecapsule.com/.../coding-for-ssds-part-2-architecture-of-an-ssd-and-benchmarking/
>>
>> Lets continue:
>> Since block sizes are between 256k-4MB, data smaller than this will
>> "probably" will not be fragmented in a reasonably empty and trimmed
>> drive. And for a brand new ssd we may speak of contiguous series
>> of blocks.
>>
>> However, as drive is used more and more and as wear leveling kicking
>> in (ie. blocks are remapped) the meaning of "contiguous blocks" will
>> erode. So any file bigger than a block size will be written to blocks
>> physically apart no matter what their block addresses says. But my
>> guess is that accessing device blocks -contiguous or not- are
>> constant time operations. So it would not contribute performance
>> issues. Right? Comments?
>>
>> So your the feeling about fragmentation/performance is probably
>> related with if the file is spread into less or more blocks. If # of
>> blocks used is higher than necessary (ie. no empty blocks can be
>> found. Instead lots of partially empty blocks have to be used
>> increasing the total # of blocks involved) then we will notice
>> performance loss.
>>
>> Additionally if the filesystem will gonna try something to reduce
>> the fragmentation for the blocks, it should precisely know where
>> those blocks are located. Then how about ssd block informations?
>> Are they available and do filesystems use it?
>>
>> Anyway if you can provide some more details about your experiences
>> on this we can probably have better view on the issue.
>
> What you really want for SSD is not defragmented files but defragmented
> free space. That increases life time.
>
> So, defragmentation on SSD makes sense if it cares more about free
> space but not file data itself.
>
> But of course, over time, fragmentation of file data (be it meta data
> or content data) may introduce overhead - and in btrfs it probably
> really makes a difference if I scan through some of the past posts.
>
> I don't think it is important for the file system to know where the SSD
> FTL located a data block. It's just important to keep everything nicely
> aligned with erase block sizes, reduce rewrite patterns, and free up
> complete erase blocks as good as possible.
>
> Maybe such a process should be called "compaction" and not
> "defragmentation". In the end, the more continuous blocks of free space
> there are, the better the chance for proper wear leveling.

There is one other thing to consider though.  From a practical 
perspective, performance on an SSD is a function of the number of 
requests and what else is happening in the background.  The second 
aspect isn't easy to eliminate on most systems, but the first is pretty 
easy to mitigate by defragmenting data.

Reiterating the example I made elsewhere in the thread:
Assume you have an SSD and storage controller that can use DMA to 
transfer up to 16MB of data off of the disk in a single operation.  If 
you need to load a 16MB file off of this disk and it's properly aligned 
(it usually will be with most modern filesystems if the partition is 
properly aligned) and defragmented, it will take exactly one operation 
(assuming that doesn't get interrupted).  By contrast, if you have 16 
fragments of 1MB each, that will take at minimum 2 operations, and more 
likely 15-16 (depends on where everything is on-disk, and how smart the 
driver is about minimizing the number of required operations).  Each 
request has some amount of overhead to set up and complete, so the first 
case (one single extent) will take less total time to transfer the data 
than the second one.

This particular effect actually impacts almost any data transfer, not 
just pulling data off of an SSD (this is why jumbo frames are important 
for high-performance networking, and why a higher latency timer on the 
PCI bus will improve performance (but conversely increase latency)), 
even when fetching data from a traditional hard drive (but it's not very 
noticeable there unless your fragments are tightly grouped, because seek 
latency dominates performance).
