Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29950 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751446AbbGUGwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 02:52:45 -0400
Subject: Re: Strange data backref offset?
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <55A86AA8.6010404@cn.fujitsu.com>
 <20150718113412.GA11450@localhost.localdomain>
 <20150719072344.GA22025@hungrycats.org> <55AC5BE6.90802@cn.fujitsu.com>
 <20150721045505.GB22025@hungrycats.org>
CC: Liu Bo <bo.li.liu@oracle.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55ADEC36.1010504@cn.fujitsu.com>
Date: Tue, 21 Jul 2015 14:52:38 +0800
MIME-Version: 1.0
In-Reply-To: <20150721045505.GB22025@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Zygo Blaxell wrote on 2015/07/21 00:55 -0400:
> On Mon, Jul 20, 2015 at 10:24:38AM +0800, Qu Wenruo wrote:
>> Zygo Blaxell wrote on 2015/07/19 03:23 -0400:
>> But I'm a little considered about the facts that extents get quite small(4K)
>> and the increasing number of backref/file extents may affect performance.
>
> At the moment I just ignore any block that already has more than 100
> references, since deduplicating those blocks can save at most 1% space,
> and I'm afraid of finding out the hard way what happens if there's over
> a million references to a single extent in btrfs.  ;)
>
>> [inband vs outband]
>> I think kernel inband deduplication should be *fast*, *simple*, and *flex*.
>> It doesn't need to be perfectly dedup every extent to its smallest space
>> usage.
>> It should be a quite nice additional option for btrfs, but only impacts the
>> normal routine to minimal.
>>
>> On the other hand, user space dedup can do all the hard work that kernel
>> dedup can't do, like what you do currently, try to do the best to reduce
>> every space usage.
>
> An in-band dedup can avoid some of these problems, especially if it
> intercepts writes before they make it to disk.  There is no need for
> complicated on-disk-extent-splitting algorithms if we can avoid writing
> extents that needed to be split in the first place.
Yes, that would be best, but it can get very tricky when things comes to 
detail.

For example, if inband dedup finds the write is duplicated with one page 
that is already written into disk, what it should do?

The already on disk one maybe written by old kernels without inband 
dedup support.
>
>> So from this respect, I'm OK with the space waste in in-band deduplication
>> if the inband dedup is simple and fast.
>
> My version of that rule is "don't compromise a working design to do
> something that gives less than 1% benefit."  ;)
>
>> [Liu Bo's patchset]
>> As Liu Bo already submit a V10 patchset, I think most of its implement is
>> quite good and straightforward, quite suitable for kernel in band dedup if
>> can be improved a little.
>>
>> The workflow is quite easy to understand:
>> 1. Hash(SHA256) the data at the unit of dedup_size.
>>     For data smaller than dedup_size, fallback to normal routine.
>> 2. If hash matches, add file extent item and backref.
>>     No need to submit the bio
>> 3. If hash not match, adds the hash to dedup tree.
>>     The bio submit/metadata modification will be done by dedup routine.
>> 4. When free a extent, deletes the hash from dedup tree.
>>
>> For the space waste problem, as dedup is done at dedup_size (can be set to
>> page size) and extent is at that size, so no space waste problem, but break
>> the original large extent into small ones even it will not have further
>> duplicated one.
>>
>> And a new dedup tree with dedup ioctl to disable/enabled it.
>>
>> [My developing dedup patchset]
>> Learned a lot from Liu Bo's patchset, mixed with some of my understanding.
>>
>> The workflow is somewhat like Liu's
>> 1. Hash(SHA256) the data at the unit of page size.
>>     Only happens for uncompressed non-inline data yet.
>> 2. If hash matches, add file extent item and backref.
>>     Skip bio submit just like Liu.
>> 3. If hash not match, go through the orinal routine.
>>     But with hook to add hash into dedup hash<->extent mapping tree.
>> 4. Remove Last Recent Use hash<->extent mapping if there is too many.
>>
>> 5. Also add hash<->extent mapping at read page time.
>> 6. Also remove all the hash<->extent mapping belongs to the extent when
>>     freeing
>>
>> As you can see, all hash<->extent mapping is stored only in memory,
>> so no new tree, even no need to use a new ioctl, just mount option is enough
>> to disable/enable dedup.
>> And large extents will still be large, don't need to be broken into smaller
>> one. Only duplicated page will be small extent(4K)
>>
>> With limited (can be tuned with mount option) number of in memory mapping,
>> overhead of read/write can be limited to a constant value.
>>
>> Also, the number of lines is small.
>> Current working one without the code to parse mount option(just hard coded
>> for testing yet) only adds about 780 lines to do dedup.
>>
>> On the other hand the cost is obvious too, not every duplicated page will be
>> deduplicated, and still can't solve the space waste problem.
>
> My approach is a little different.  RAM usage is my limiting factor, so
> I've selected data structures to minimize it, and traded against some
> extra I/O.
>
> I use a much smaller hash (40-50 bits, depending on the size of the
> filesystem and expected duplicate rate) that is intentionally sized
> to false-positive on about 0.1% of matching hashes--no more, no less.
> The cost is having to read all possibly duplicate blocks to determine if
> the data is really duplicate, and 0.1% of the time I get a false positive.
> The benefit is that I can get more hash table coverage per unit of RAM,
> so I can use a tiny machine to dedup a huge filesystem.
I tried to use CRC32 as hash other than SHA256, as it can reuse as checksum.

But I found things get tricky if I needs to compare page by page to 
determine if they are really the same.
Which means you may start a lot of new read just to dedup one new write,
not only impact the performance but also make the original read routine 
to be a mess.
And that's more harder than my previous expect when it comes to coding.

So I choose SHA256 as that's will skip the hard to code compare parts.
>
> I use random drop instead of LRU on the hash table.  Hashes of duplicate
> blocks are ordered to expire after hashes of unique blocks, but hashes
> within both groups expire in random order.  When I find a pair of
> duplicate blocks in two extents, I check the adjacent blocks to see if
> they are also identical.  If they are, I expand the duplicate block range
> and repeat, resulting in a maximum-length sequence of duplicate blocks.
> Typical duplicate files contain long sequences of duplicate blocks where
> each sequence contains blocks that are mostly unique except when they
> appear in the sequence (e.g. a JPEG photo will contain thousands of
> blocks, each of which are only ever found in other copies of the same
> JPEG photo).  It's only necessary to find any one of those blocks in the
> block hash table--the others will be found because they are adjacent
> to the block in the hash table.  In other words, for typical cases we
> can just throw most of the block hash table away, keeping only a small
> sample of the blocks.
The adjust blocks theory is completely right and makes sense, but I 
think this idea is trading IO for memory usage.

The problem is still the same, when write, you still needs to read 
unrelated(although potential duplicated) contents to compare or do 
adjustment check.

If that's all happens at user space, I'm completely OK with it.
User knows the idea/mechanism/behavior of it, so user choose to use it.

But when it comes to kernel, any write will probably cause not only 
write bio, but also read bio first, making original pure write sequence 
into rw mixed one, impacting the performance.

IMHO, any implement involved re-read at write time, is just trading I/O 
for memory.
If I'm wrong, please point it out.
In typical case, with your method, it can restore one example blocks.
But when a hash of first write hits the hash of example blocks, adjusted 
blocks needs to be read out to test if they matches.
The result would be, you need to write 16 pages original, but dedup 
needs to do 15(the example one is in memory already) pages read first.

That would be OK for SSD as it reads are faster than write, but for HDD,
read speed is the same with write, so IO time is not really saved, only 
disk space usage.

So unfortunately, I'm not a big fan of the idea that needs read before 
really write.

>
> These two techniques save a _lot_ of RAM compared to approaches based
> on large, collision-free hashes and LRU.  I can intentionally undersize
> the block hash table's RAM allocation by multiple orders of magnitude
> and still find 99% of duplicate blocks on a filesystem.
>
> In my case I'm *really* starved for RAM--I push 25TB of data through a
> 10GB hash table with a 45% duplicate rate.  That's only 10% of the RAM
> I would require for full hash table coverage coverage of the filesystem.
>
I'm a little interesting about the read I/O.
How much read I/O does it start?

>> But IMHO such implement can be improved further easily:
>> TODO list:
>> 1. merge duplicated extent into larger one if possible.
>> For example:
>> Existing File 1:
>> 0	4K	8K	12K
>> |AAAAAAA|BBBBBBB|CCCCCCC|
>>
>> |<------Extent A------->|
>> New write into file2:
>> Current:
>> |AAAAAAA|BBBBBBB|
>> |-ExtB--|-ExtC--|
>>
>> Ext B will point to extent A with offset 0, nr 4096.
>> Ext C will point to extent A with offset 4096, nr 4096.
>>
>> TODO version:
>> |AAAAAAA|BBBBBBB|
>> |-----ExtD------|
>> Ext D will point to extent A with offset 0, nr 8192.
>
> My experiments with this so far found some nasty feedback loops with
> extent coalescing, where we coalesce AAA and BBB together into AAABBB,
> then split them apart again later on when we discover files with AAACCC
> or BBBDDD sequences.
>
> I find that once an extent has been split for dedup, the best thing to
> do is to leave it alone.  In the vast majority of cases such extents are
> split into smaller pieces until the extent edges match some logical
> boundary in the data, but then they remain stable after that.
>
> E.g. if several files are copied from a filesystem into a VM filesystem
> image, the VM image will be broken up into extents that match the
> boundaries of the files.  Once that is done, there will typically be no
> further fragmentation as any further duplicates of these extents will
> be more copies of the same files--and therefore have the same length.
> Another copy of the VM image just gets broken into the same sized
> extents as the first copy.
>
> There are examples where this is not true, but they tend to be really
> bad use cases for deduplication.  e.g. a database file might have lots
> of small duplicate fragments--but typically one wants a database file
> to be nocow and defragmented, and the gains from these operations far
> outweigh the benefits (and costs!) of allowing dedup to touch the file
> at all.
>
> If many small consecutive extents can be *proven* unique, they might be
> worth defragmenting.  Maybe.
Thanks for the advice a lot.
But maybe you got me wrong, in my implement, not extent is split, so for 
the Extent A in the example, it's always a whole extent.
Extent B is just a new reference to it, using the part of it.

One debug-tree output from my already running test could explain it better:
------
Extent tree:
         item 4 key (12845056 EXTENT_ITEM 16384) itemoff 15989 itemsize 169
                 extent refs 5 gen 6 flags DATA
                 extent data backref root 5 objectid 257 offset 24576 
count 1
                 extent data backref root 5 objectid 257 offset 16384 
count 1
                 extent data backref root 5 objectid 257 offset 0 count 1
                 extent data backref root 5 objectid 257 offset 20480 
count 1
                 extent data backref root 5 objectid 257 offset 12288 
count 1

Fs tree:
# the first 16K is written as a large extent.
         item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 0 nr 16384 ram 16384
                 extent compression 0
# the rest are all deduped.
         item 7 key (257 EXTENT_DATA 16384) itemoff 15760 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 4096 nr 4096 ram 16384
                 extent compression 0
         item 8 key (257 EXTENT_DATA 20480) itemoff 15707 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 4096 nr 4096 ram 16384
                 extent compression 0
         item 9 key (257 EXTENT_DATA 24576) itemoff 15654 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 4096 nr 4096 ram 16384
                 extent compression 0
         item 10 key (257 EXTENT_DATA 28672) itemoff 15601 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 4096 nr 4096 ram 16384
                 extent compression 0
------

item 7~10 just points to one part of the bigger extents, not split.
So merge would be quite nice to reduce the backref and file extents.

Even it can't expend the range, no split will happen anyway.
>
>> This will both reduce space waste and metadata size.
>> But like the implement itself, such behavior won't always do it best, and
>> may fallback to the old one.
>>
>> 2. Persist dedup hash<->extent map.
>> As we already have the dedup ioctl number, in this implement, we can use it
>> to pin a dedup hash mapping into memory and out of the LRU control.
>> This could hugely improve the flexibility of kernel inband dedup, and put
>> the dedup policy out of kernel, making application handle things better than
>> kernel.
>
> My persistent hash table is just a copy of the in-memory hash table (or
> mmap the table as a file on disk).  The in-memory hash table is just a
> giant array of (hash, physical) tuples arranged to encode random-drop
> information and some of the hash bits in the address of each table entry.
> It is fixed-size.  The administrator decides how much RAM to devote to
> dedup, and once the table is loaded the RAM usage is constant.

The persist hash map is just for special use case, like system admin 
knows some files are easy to have duplication, then pin the hash map 
into memory to improve dedup rate.

And to move the responsibility of OOM or other problem to sysadmins. :)
Only use the simplest policy in kernel, if user not happy with it,
then implement a good policy in user space.

But this is just a TODO, no goal or milestone yet.

>
> On the other hand, my design has trade-offs:  because each table entry
> is a hash and a physical block, and there's no synchronization with the
> kernel, balancing the filesystem effectively destroys the hash table.  :-P
>
>>> On a heavily defragmented filesystem the data copy required could be a
>>> little under 2GB for a single pair of cloned ranges (in the worst case
>>> of 4K cloned in two maximum-sized extents).  Currently FILE_EXTENT_SAME
>>> refuses to do work involving more than 32MB of reads for a single
>>> extent pair.  There's a pretty big gap between 32MB of reads and 4GB of
>>> reads _and_ writes.  FILE_EXTENT_SAME also takes a vector of extents,
>>> which multiply the work.
>> So breaking large extent is always needed, even in my implement, I limit the
>> largest uncompressed extent to be 512K
>> (For 4K page size, 512K needs 128 hashes, at each takes 32bytes, hash will
>> be just 1 page).
>
> Huge!  ;)
>
> I have the same 4K page size, but even with a fully populated hash table
> (all blocks on disk indexed) I use only 1712 bytes per 512K--including
> the block pointers and indexing overhead.
Did you mean 1712 bytes for a dedup unit? Or 1712 is for several dedup 
unit that covers the 512K? As 1712 can't be dived by 128...

In fact, I can reduce the space usage by just(not so easy to call it 
just anyway) change dedup size to 512K. So just one btrfs_dedup_hash for 
512K other than original 128 dedup_hash for 512K.
That's also why Liu Bo uses tunable dedup_size.

Anyway, my dedup_hash struct is really huge...
It's 120 bytes with all overhead for one btrfs_dedup_hash (and one page 
yet).

>  At about 157 bytes per 512K
> (the amount of RAM I have to run dedup) the dedup still covers 92%
> of duplicate extents with length 64K, with less coverage for smaller
> extents and more coverage for larger extents.  The size distribution
> of typical filesystems means I get 99% of all duplicate blocks.
>
Pretty impressive, but still a little worried about the code 
complexibility especially when it needs to go into kernel.

At last, thanks for your impressive dedup ideas and test data.

Thanks,
Qu
