Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60652 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbbGVBt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 21:49:57 -0400
Subject: RE: Discuss on inband dedup implement (Original "strange data backref
 offset")
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <55A86AA8.6010404@cn.fujitsu.com>
 <20150718113412.GA11450@localhost.localdomain>
 <20150719072344.GA22025@hungrycats.org> <55AC5BE6.90802@cn.fujitsu.com>
 <20150721045505.GB22025@hungrycats.org> <55ADEC36.1010504@cn.fujitsu.com>
 <20150721221446.GC22025@hungrycats.org>
CC: Liu Bo <bo.li.liu@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55AEF6C0.5070207@cn.fujitsu.com>
Date: Wed, 22 Jul 2015 09:49:52 +0800
MIME-Version: 1.0
In-Reply-To: <20150721221446.GC22025@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change subject to reflect the core of the conversation.

Zygo Blaxell wrote on 2015/07/21 18:14 -0400:
> On Tue, Jul 21, 2015 at 02:52:38PM +0800, Qu Wenruo wrote:
>> Zygo Blaxell wrote on 2015/07/21 00:55 -0400:
>>> An in-band dedup can avoid some of these problems, especially if it
>>> intercepts writes before they make it to disk.  There is no need for
>>> complicated on-disk-extent-splitting algorithms if we can avoid writing
>>> extents that needed to be split in the first place.
>> Yes, that would be best, but it can get very tricky when things comes to
>> detail.
>>
>> For example, if inband dedup finds the write is duplicated with one page
>> that is already written into disk, what it should do?
>
> Replace all the duplicate blocks with refs to existing data on disk
> (making partial references to existing extents) and write the rest to
> disk the usual way.  I think that's what you're already doing.  ;)
Yes, completely what am I doing.
And it would be quite soon to see the first version patchset. :)

>
> In my dedup I divide extent match candidates into "perfect" and
> "imperfect" cases.  A perfect match has the boundaries of duplicate and
> unique block sequences aligned to the boundaries of the extents, so no
> extent splitting is required and no waste accumulates.  An imperfect match
> requires splitting one or more extents in order to create perfect matches.
>
> It's reasonable to run dedup in a mode where imperfect matches are
> disabled, so only perfect matches are used for dedup.  This still gets
> a lot of duplicated data, it doesn't waste space, and it's _much_ faster
> when the data includes a lot of big uncompressed extents.  It works well
> on a development machine with lots of similar source trees checked out,
> or many chroot build environments populated with similar binaries.
> Unfortunately it doesn't work at all when there are big defragmented
> VM images with copies of filesystem files.  Sometimes this tradeoff is
> worth it, sometimes it's not.  It depends on the data and it's just
> one if statement to turn it on or off.
>
> It's also possible to operate in a mode where the distinction between
> perfect and imperfect matches is ignored.  This is also fast but it
> wastes space.  How much space is wasted depends on the writing pattern
> on the disk.  It doesn't seem to waste more space than btrfs already
> does when random writes occur over a large contiguous extent--and if
> that problem can be solved, it can be solved for deup the same way.
>
>> The already on disk one maybe written by old kernels without inband dedup
>> support.
>
> I don't think it matters if the blocks were written with or without
> dedup support before (I've never had to make that distinction in code).
> If there is a persistent hash table then that table might be missing data
> from an old kernel, but if we're just hashing blocks as they appear in
> RAM then no kernel other than the currently running one matters.
>
>>> I use a much smaller hash (40-50 bits, depending on the size of the
>>> filesystem and expected duplicate rate) that is intentionally sized
>>> to false-positive on about 0.1% of matching hashes--no more, no less.
>>> The cost is having to read all possibly duplicate blocks to determine if
>>> the data is really duplicate, and 0.1% of the time I get a false positive.
>>> The benefit is that I can get more hash table coverage per unit of RAM,
>>> so I can use a tiny machine to dedup a huge filesystem.
>> I tried to use CRC32 as hash other than SHA256, as it can reuse as checksum.
>>
>> But I found things get tricky if I needs to compare page by page to
>> determine if they are really the same.
>> Which means you may start a lot of new read just to dedup one new write,
>> not only impact the performance but also make the original read routine to
>> be a mess.
>> And that's more harder than my previous expect when it comes to coding.
>
> I looked at CRC32 because it would have been really nice to reuse the
> existing checksums...but it's too small.  The maximum filesystem size for a
> 32-bit hash and a 0.1% FP rate is about 32MB.
>
>> So I choose SHA256 as that's will skip the hard to code compare parts.
>
> There's already a read-and-compare in the extent-same ioctl.  :-/
Yes, but the extent same ioctl needs 2 inode. (one already provided by 
ioctl system call)
One for the source and one for the dest, which makes codes easy to 
implement as we can just use VFS calls to read the needed pages.

But the problem is, for dedup, there is only hash <-> extent mapping.
We only know the corresponding bytenr of a hash, not a inode.

If even using the read-compare method, which means at write routine, we 
will resuse read routine, causing more complicated read/write path 
combination to test, and later read routine change will be quite dirty 
to avoid impact on write routine.

And what's worse is, an extent can be referred by several different 
inodes, so even for the best case, we need to find an inode using 
backref and then use address space calls to read the neede pages.

That will leads to the hell of delayed ref.
As at write time, backref is delayed, it needs not only search the 
extent tree for backref item but also go through delayed refs. (Such 
things were the reason causing crazy quota numbers before and I tried to 
fix in 4.2-rc1)

And that's what I feared to face, complicated read/write coupling with 
backref search nightmare.
>
>>> I use random drop instead of LRU on the hash table.  Hashes of duplicate
>>> blocks are ordered to expire after hashes of unique blocks, but hashes
>>> within both groups expire in random order.  When I find a pair of
>>> duplicate blocks in two extents, I check the adjacent blocks to see if
>>> they are also identical.  If they are, I expand the duplicate block range
>>> and repeat, resulting in a maximum-length sequence of duplicate blocks.
>>> Typical duplicate files contain long sequences of duplicate blocks where
>>> each sequence contains blocks that are mostly unique except when they
>>> appear in the sequence (e.g. a JPEG photo will contain thousands of
>>> blocks, each of which are only ever found in other copies of the same
>>> JPEG photo).  It's only necessary to find any one of those blocks in the
>>> block hash table--the others will be found because they are adjacent
>>> to the block in the hash table.  In other words, for typical cases we
>>> can just throw most of the block hash table away, keeping only a small
>>> sample of the blocks.
>> The adjust blocks theory is completely right and makes sense, but I think
>> this idea is trading IO for memory usage.
>>
>> The problem is still the same, when write, you still needs to read
>> unrelated(although potential duplicated) contents to compare or do
>> adjustment check.
>>
>> If that's all happens at user space, I'm completely OK with it.
>> User knows the idea/mechanism/behavior of it, so user choose to use it.
>>
>> But when it comes to kernel, any write will probably cause not only write
>> bio, but also read bio first, making original pure write sequence into rw
>> mixed one, impacting the performance.
>>
>> IMHO, any implement involved re-read at write time, is just trading I/O for
>> memory.
>> If I'm wrong, please point it out.
>
> That's precisely the tradeoff I made:  up to 0.1% more I/O for unique
> blocks, and duplicate writes would become reads instead (assuming I moved
> my dedup daemon into the kernel).  There is some extra seeking on writes
> to confirm duplicate pages--but when they are confirmed, the writes are
> no longer necessary and their I/O can be dropped.
>
> The payoff is that it requires 100 times less RAM, so it can coexist
> with other things on a medium-sized machine.

Quite convincing trade off now.

But the above extent reading problem is still here.
Although I may also be wrong as I'm not quite similar with VFS and filemap.

If there is any good kernel API to read pages directly by bytenr without 
using filemap/address space infrastructure, I'll be quite happy to try it.

>
>> In typical case, with your method, it can restore one example blocks.
>> But when a hash of first write hits the hash of example blocks, adjusted
>> blocks needs to be read out to test if they matches.
>> The result would be, you need to write 16 pages original, but dedup needs to
>> do 15(the example one is in memory already) pages read first.
>>
>> That would be OK for SSD as it reads are faster than write, but for HDD,
>> read speed is the same with write, so IO time is not really saved, only disk
>> space usage.
>>
>> So unfortunately, I'm not a big fan of the idea that needs read before
>> really write.
>
> If you insist on doing the ZFS trick where duplicate writes never touch
> the disk at all, you just need big hashes and absurd quantities of RAM.
> I'm trying to make live dedup practical on much smaller systems.
Or use LRU to further reduce the deduplication rate and code size. :)

Another reason I'm a little worried about the your near perfect dedup 
method is the code complexility and the policy.

For complexility problem, more codes means more bug, and if bug 
happens(it's a miracle no happen) it's a kernel bug...
 From kernel warning to crash to data corruption...
In fact, even I tried my best to reuse every possible existing routine, 
my patchset has already reach 800 lines (with about 50~100 lines 
comments), even without the last mount option part.
I'm quite happy to reduce lines of codes, but not adding so much...

Another problem is, although more political problem other than practical 
one, kernel should only provide mechanism, not a policy, which should be 
done at user space.
For me, the adjustment check one is already a policy, as it makes the 
assumption that most duplicated page will be adjusted.

But this is not so convincing anyway, as kernel already made a lot of 
decision using different policy, like memory watermark, swappiness and 
so on.
>
>>> These two techniques save a _lot_ of RAM compared to approaches based
>>> on large, collision-free hashes and LRU.  I can intentionally undersize
>>> the block hash table's RAM allocation by multiple orders of magnitude
>>> and still find 99% of duplicate blocks on a filesystem.
>>>
>>> In my case I'm *really* starved for RAM--I push 25TB of data through a
>>> 10GB hash table with a 45% duplicate rate.  That's only 10% of the RAM
>>> I would require for full hash table coverage coverage of the filesystem.
>>>
>> I'm a little interesting about the read I/O.
>> How much read I/O does it start?
>
> For each new block added to the filesystem, calculate its hash and
> (if known) its physical address.  Usually no read is required because
> we're talking about a block already in memory.
>
> If the block hash is in the table, but the table has the same physical
> address for the block (in case of multiple entries, any matching entry
> will suffice) the block is already deduped and we are done (this
> would only be relevant to an in-kernel implementation if it wanted to
> opportunistically dedup on reads).
>
> Next we go through all the hash table entries at different physical
> addresses from the input block.  We read the block listed in the hash
> table (on average, we do this twice 0.1% of the time, and 3 times 0.0001%
> of the time) and compare it to the new block.  If all the blocks
> are different, our new block is unique, so we add it to the hash table
> (possibly forcing allocation so it has a known physical address) and
> we are done.  By this point we've read an extra 4.004K on average for
> duplicate blocks, and just 0.004K for unique blocks.
>
> If we have a pair of identical blocks in different physical locations,
> we read forward and backward in from both until we hit some reason to
> stop (including:  perfect match found (all the extent boundaries match
> exactly), different block data, end or beginning of one of the files,
> exceeding the 16MB work limit of extent-same, I/O errors, etc).  This
> can read up to 16x2 = 32MB, although it is likely that half of those
> reads were already in the page cache.  If we have a perfect match at
> this point we have all the arguments required for extent-same, so we
> can call that and we are done.  Extent-same will do no I/O since the
> data was very recently read into cache.
Normally, I won't consider the kernel page cache, just consider that any 
read will start a real I/O.

As page cache is not what we can take control, especially under memory 
pressure.
>
> Note that when we read ahead from a matching block, we are also processing
> later new blocks entering the filesystem.  Typically when these blocks are
> duplicate it means that we have deleted them before the hash calculator
> gets to process them, so some of the I/O we spent above is reclaimed here.
>
> If we found only imperfect matches, we keep searching (up to some
> arbitrary limit, like 10) other files containing the physical block,
> repeating the steps above.  This means we are now reading up to 16MB
> times whatever the limit is.  If we find a perfect match at any point
> we handle it as above.
>
> If we found only imperfect matches, we do extent-splitting on the best
> imperfect match found.  Extent-splitting requires up to 2GB of reads
> and 2GB of writes in the worst possible case.  If this is too much I/O
> we can stop just before here and create a new block hash table entry
> as if the block was a non-duplicate.
>
> When extents are split by copying, they show up as new writes which
> are immediately fed back into dedup.  This repeats until the extents
> (and all their references) are fully fragmented into runs of unique and
> duplicate blocks, and the duplicate blocks are deduped.  The number
> of passes required depends on the history of previous deduplication,
> defrag, snapshots, and whatever optimizations were implemented in the
> dedup engine.
>
>> The persist hash map is just for special use case, like system admin knows
>> some files are easy to have duplication, then pin the hash map into memory
>> to improve dedup rate.
>>
>> And to move the responsibility of OOM or other problem to sysadmins. :)
>> Only use the simplest policy in kernel, if user not happy with it,
>> then implement a good policy in user space.
>>
>> But this is just a TODO, no goal or milestone yet.
>
> My target environment is a file server device where up to 75% of the
> system RAM might be devoted to dedup.  It is not something that is
> intended to run unnoticed on a smartphone.
The original thought on persist hash map is for database, hard to 
imagine right?

 From what I read from Oracle datasheet, they claim their database can 
take full use of ZFS deduplication, so I consider such persist hash map 
idea as a supplement to the uncertain LRU drop.
But that's just a future idea yet...

>
>>> I have the same 4K page size, but even with a fully populated hash table
>>> (all blocks on disk indexed) I use only 1712 bytes per 512K--including
>>> the block pointers and indexing overhead.
>> Did you mean 1712 bytes for a dedup unit? Or 1712 is for several dedup unit
>> that covers the 512K? As 1712 can't be dived by 128...
>
> My hash table entries look like this:
>
> 	64 bit hash
> 	AAAAAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
>
> 	64 bit physical address
> 	PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPZZZZZZZZZZZZ
>
> The 21 "A" bits are all the same within a page--I have 2^21 pages in
> my test configuration (8GB).  They don't need to be stored inside the
> hash table entry since they can be inferred from the address of the hash
> table entry.  Similarly the last 12 "Z" bits are always zero in physical
> addresses because of the 4K block size, so I don't store those either.
>
> That means my hash table entries are actually 64 + 64 - 21 - 12 = 95
> bits long.  On a 16TB filesystem with 4KB block size every single bit
> in a hash table entry requires another 512MB of RAM, so I pack them into
> pages without aligning them to byte boundaries.
>
> For some time I was experimenting with making the hash table entries
> even smaller (variable-length encodings and LZMA compressing each page)
> and I got as low as 41 bits per entry with a high CPU overhead.  Later I
> made the observation about adjacent blocks and random drop in the block
> hash table which allowed much larger RAM savings without as much CPU
> overhead, so my hash table entries are now much larger than they were
> in earlier versions of my code.
Already quite awesome.

BTW, is your userspace dedup daemon open-source?
It would be quite nice if we can refer it to improve further.

Thanks,
Qu
>
>> In fact, I can reduce the space usage by just(not so easy to call it just
>> anyway) change dedup size to 512K. So just one btrfs_dedup_hash for 512K
>> other than original 128 dedup_hash for 512K.
>> That's also why Liu Bo uses tunable dedup_size.
>
> Anyone can increase the block size to make their dedup faster.  We lose
> 100% of all duplicate extents that are smaller than (or just not aligned
> to) the block size.
>
>> Anyway, my dedup_hash struct is really huge...
>> It's 120 bytes with all overhead for one btrfs_dedup_hash (and one page
>> yet).
>
> I'm told ZFS is closer to 320.  ;)
>
>>> At about 157 bytes per 512K
>>> (the amount of RAM I have to run dedup) the dedup still covers 92%
>>> of duplicate extents with length 64K, with less coverage for smaller
>>> extents and more coverage for larger extents.  The size distribution
>>> of typical filesystems means I get 99% of all duplicate blocks.
>>>
>> Pretty impressive, but still a little worried about the code complexibility
>> especially when it needs to go into kernel.
>>
>> At last, thanks for your impressive dedup ideas and test data.
>>
>> Thanks,
>> Qu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
