Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46415 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754068AbbGTCYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jul 2015 22:24:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Strange data backref offset?
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Liu Bo <bo.li.liu@oracle.com>
References: <55A86AA8.6010404@cn.fujitsu.com>
 <20150718113412.GA11450@localhost.localdomain>
 <20150719072344.GA22025@hungrycats.org>
CC: btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <55AC5BE6.90802@cn.fujitsu.com>
Date: Mon, 20 Jul 2015 10:24:38 +0800
MIME-Version: 1.0
In-Reply-To: <20150719072344.GA22025@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Zygo Blaxell wrote on 2015/07/19 03:23 -0400:
> On Sat, Jul 18, 2015 at 07:35:31PM +0800, Liu Bo wrote:
>> On Fri, Jul 17, 2015 at 10:38:32AM +0800, Qu Wenruo wrote:
>>> Hi all,
>>>
>>> While I'm developing a new btrfs inband dedup mechanism, I found btrfsck and
>>> kernel doing strange behavior for clone.
>>>
>>> [Reproducer]
>>> # mount /dev/sdc -t btrfs /mnt/test
>>> # dd if=/dev/zero of=/mnt/test/file1 bs=4K count=4
>>> # sync
>>> # ~/xfstests/src/cloner -s 4096 -l 4096 /mnt/test/file1 /mnt/test/file2
>>> # sync
>>>
>>> Then btrfs-debug-tree gives quite strange result on the data backref:
>>> ------
>>> <EXTENT TREE>
>>>          item 4 key (12845056 EXTENT_ITEM 16384) itemoff 16047 itemsize 111
>>>                  extent refs 3 gen 6 flags DATA
>>>                  extent data backref root 5 objectid 257 offset 0 count 1
>>>                  extent data backref root 5 objectid 258 offset
>>> 18446744073709547520 count 1
>>>
>>> <FS TREE>
>>>          item 8 key (257 EXTENT_DATA 0) itemoff 15743 itemsize 53
>>>                  extent data disk byte 12845056 nr 16384
>>>                  extent data offset 0 nr 16384 ram 16384
>>>                  extent compression 0
>>>          item 9 key (257 EXTENT_DATA 16384) itemoff 15690 itemsize 53
>>>                  extent data disk byte 12845056 nr 16384
>>>                  extent data offset 4096 nr 4096 ram 16384
>>>                  extent compression 0
>>> ------
>>>
>>> The offset is file extent's key.offset - file exntent's offset,
>>> Which is 0 - 4096, causing the overflow result.
>>>
>>> Kernel and fsck all uses that behavior, so fsck can pass the strange thing.
>>>
>>> But shouldn't the offset in data backref matches with the key.offset of the
>>> file extent?
>>>
>>> And I'm quite sure the change of behavior can hugely break the fsck and
>>> kernel, but I'm wondering is this a known BUG or feature, and will it be
>>> handled?
>>
>> Also found this before, one of the benefits is to save metadata in extent
>> tree, that is, if we overwrite inside an extent, the extent ref count
>> increases to 2 since both use (key.offset - extent_offset).
>>
>> 0k                  12k
>> |-------------------|
>>       |--------|
>>       4k       8k
>>
>> one EXTENT_DATA item is 0k and the other one is 8k, the corresponding
>> refs will be (0k - 0) and (8k - 8k).
Thanks Liu,
This makes sense and quite convincing, so I'm OK with it now.
>>
>> It's a format change so it won't be easy to make a change.  I'd prefer a
>> workaround on clone side.
As you explained, and since current kernel and fsck works, even it's a 
strange minus number, I'm OK with it.
So I prefer not to change behavior even it's odd.
>
> The workaround for dedup currently involves copying data.  It could be
> done by manipulating the metadata directly, but btrfs doesn't seem to
> provide this.
>
> Suppose our dedup engine has identified duplicate blocks in distinct
> extents, and we want to replace them by cloning:
>
> 0k                  12k
> |AAAAABBBBBBBBCCCCCC|     <- file #1 extent #1
>       |BBBBBBBB|           <- file #2 extent #2
>       4k       8k
>
> If we clone the "B" part of extent #1 over extent #2, we save one block
> by eliminating the last reference to extent #2; however, if file #1 is
> later deleted, we waste 8K.  File #2 will refer to only 4K out of extent
> #1's 12K.  Any further clones of file #2 will add references to this
> 12K extent.  The 8K of wasted data cannot be accessed from userspace,
> so it's unavailable for allocation and can't be reused by future clones.
>
> Assuming dedup finds many further copies of the "B" data, and they're
> all replaced by clones referring to the "B" blocks of extent #1, those
> 8K are effectively wasted forever.  If extent #1 is larger (up to 1GB),
> more space is wasted.  The only way to get the space back after this
> failure is to locate every reference to extent #1 in the entire filesystem
> (i.e. every instance of the "B" data) and delete it.
>
> 0k                  12k
> |AAAAABBBBBBBBCCCCCC|     <- file #1 extent #1, "B" shared with file #2
>   aaaa|BBBBBBBB|ccccc      <- file #2 "a" and "c" blocks referenced
>       4k       8k             but not used (i.e. wasted) in file #2
>
> If we clone extent #2 over extent #1, we avoid the above problem, but
> we save nothing.  The refs to extent #1 from file #1 will keep the "B"
> blocks from extent #1 on disk even though they are not accessible:
>
> 0k   /bbbbbbbb\     12k   <- file #1 unused blocks from extent #1
> |AAAA|^wasted^|CCCCC|     <- file #1 blocks "A" and "C" from extent #1
>       \BBBBBBBB/           <- file #1 blocks "B" from extent #2
>       |BBBBBBBB|           <- file #2 extent #2 shared with file #1
>       4k       8k
>
> If extent #2 is larger than 4K, but only 4K of data is duplicate, then
> we get the same result as when we replaced extent #2 with a clone of
> part of extent #1:  wasted space.
>
> A few popular block values on a filesystem can end up being duplicated
> thousands of times, so we can't afford to just ignore them.  Such blocks
> are usually part of much larger extents where the extents as a whole are
> unique, so we can't get rid of the duplicate blocks without modifying
> the extent boundaries.
>
> Dedup has to replace extent #1 (and in some cases also extent #2) with
> up to three new extents so that all duplicate extents have matching
> boundaries before cloning:
>
> 0k                  12k   <- file #1 extent #1 deleted
> |AAAA|BBBBBBBB|CCCCC|     <- file #1 extent #3, #4, #5
>       |BBBBBBBB|           <- file #2 extent #2
>       4k       8k          <- extent boundaries around "B" aligned
>
> Then we can clone extent #2 from file #2 over extent #4 in file #1:
>
> 0k                  12k   <- file #1 is now extents #3, #2, #5
> |AAAA|BBBBBBBB|CCCCC|     <- replace extent #4 with clone of #2
>       |BBBBBBBB|           <- file #2 extent #2 shared with file #1
>       4k       8k          <- no wasted space in either file
>
> Since we are just deleting extent #4 in this case, we didn't have to
> bother creating it.  An optimized implementation could skip that step.
> A differently optimized implementation keeps #4 but deletes #2 because
> then file #1 can be read with fewer seeks:
>
> 0k                  12k   <- file #1 data physically contiguous
> |AAAA|BBBBBBBB|CCCCC|     <- file #1 is now extents #3, #4, #5
>       |BBBBBBBB|           <- file #2 extent #4 shared with file #1
>       4k       8k          <- file #2 extent #2 replaced by extent #4
>
> Both extents might have other shared references.  When any extent is
> split up, all references to the extent have to be split the same way.
>
> How do we split extents into smaller pieces?  Copy the contents to
> multiple new extents, then use those new extents to replace the original
> extent along the same boundaries as the duplicate data block ranges.
>
> Currently a user-space dedup agent has to rely on ioctls like
> FILE_EXTENT_SAME and DEFRAG_RANGE to provide the required atomic
> copy-and-replace semantics, and FIEMAP to discover where existing
> extent boundaries are.  FIEMAP doesn't provide a complete picture of the
> underlying extent structure--in particular, FIEMAP does not tell us when
> a logical extent boundary does not match a btrfs physical extent boundary
> and a split is required.  DEFRAG_RANGE refuses to split some contiguous
> extents into smaller, non-contiguous extents, and even when it does,
> there are other heuristics in btrfs that reassemble the carefully sized
> smaller extents back into useless larger ones.  FILE_EXTENT_SAME doesn't
> split physical extents when it needs to--it just creates broken shared
> extent references with all the problems described above.
>
> Copying the data to multiple temporary files in user-space (so they
> can't be coalesced into larger extents) seems to create the split extents
> required, and FILE_EXTENT_SAME can be used to atomically splice the new
> extents back into the original files, replacing the original extents.
> Userspace is left to find all the refs itself--there are several ways to
> do that with various time/space/complexity trade-offs.  It's _possible_
> to implement a working dedup in userspace now, but it's not easy to get
> every corner case right.
>
> It's a little easier in the kernel.  FILE_EXTENT_SAME could split
> extents as required, and use a non-broken internal implementation
> of DEFRAG_RANGE that doesn't refuse to copy data it was asked to.
> A flag can be added somewhere to disable the heuristics that coalesce
> consecutive extents together when those extents are intentionally split,
> but preserve the existing behavior of coalescing consecutive duplicate
> extents when they are the maximum length accepted by FILE_EXTENT_SAME.
> The kernel can chase all the extent backrefs more easily and completely
> than userspace can.  An in-kernel dedup might even be able to make wasted
> blocks accessible again if their contents should reappear in new files.
Yes, your method about split extents sound quite good, and can reduce on 
disk space usage to minimal.

Before:
0	4K	8K	12K	20K
File A:
|AAAAAAA|AAAAAAA|BBBBBBB|CCCCCCC|
On disk extent:
|<--------Extent A------------->|

File B:
|AAAAAAA|AAAAAAA|CCCCCCC|CCCCCCC|
|<--------Extent B------------->|

Total data: 2x20K extents, use 40K on disk
Metadata: 2 extent items, with 1 inline backref in each.
2 file extent items.

After:
File A:
|AAAAAAA|AAAAAAA|BBBBBBB|CCCCCCC|
|--ExtC-|--ExtC-|--ExtD-|--ExtE-|

File B:
|AAAAAAA|AAAAAAA|CCCCCCC|CCCCCCC|
|--ExtC-|--ExtC-|--ExtE-|--ExtE-|

Total data: 3x4K extents, use 12K on disk
Metadata: 3 extent items, ExtC with 3 inline backref, ExtD with 1 inline 
backref, ExtE with 2 inline backref.
8 file extent items.

If I'm wrong, I'm happy if anyone can point it out.

But I'm a little considered about the facts that extents get quite 
small(4K) and the increasing number of backref/file extents may affect 
performance.

[inband vs outband]
I think kernel inband deduplication should be *fast*, *simple*, and *flex*.
It doesn't need to be perfectly dedup every extent to its smallest space 
usage.
It should be a quite nice additional option for btrfs, but only impacts 
the normal routine to minimal.

On the other hand, user space dedup can do all the hard work that kernel 
dedup can't do, like what you do currently, try to do the best to reduce 
every space usage.

So from this respect, I'm OK with the space waste in in-band 
deduplication if the inband dedup is simple and fast.

[Liu Bo's patchset]
As Liu Bo already submit a V10 patchset, I think most of its implement 
is quite good and straightforward, quite suitable for kernel in band 
dedup if can be improved a little.

The workflow is quite easy to understand:
1. Hash(SHA256) the data at the unit of dedup_size.
    For data smaller than dedup_size, fallback to normal routine.
2. If hash matches, add file extent item and backref.
    No need to submit the bio
3. If hash not match, adds the hash to dedup tree.
    The bio submit/metadata modification will be done by dedup routine.
4. When free a extent, deletes the hash from dedup tree.

For the space waste problem, as dedup is done at dedup_size (can be set 
to page size) and extent is at that size, so no space waste problem, but 
break the original large extent into small ones even it will not have 
further duplicated one.

And a new dedup tree with dedup ioctl to disable/enabled it.

[My developing dedup patchset]
Learned a lot from Liu Bo's patchset, mixed with some of my understanding.

The workflow is somewhat like Liu's
1. Hash(SHA256) the data at the unit of page size.
    Only happens for uncompressed non-inline data yet.
2. If hash matches, add file extent item and backref.
    Skip bio submit just like Liu.
3. If hash not match, go through the orinal routine.
    But with hook to add hash into dedup hash<->extent mapping tree.
4. Remove Last Recent Use hash<->extent mapping if there is too many.

5. Also add hash<->extent mapping at read page time.
6. Also remove all the hash<->extent mapping belongs to the extent when
    freeing

As you can see, all hash<->extent mapping is stored only in memory,
so no new tree, even no need to use a new ioctl, just mount option is 
enough to disable/enable dedup.
And large extents will still be large, don't need to be broken into 
smaller one. Only duplicated page will be small extent(4K)

With limited (can be tuned with mount option) number of in memory 
mapping, overhead of read/write can be limited to a constant value.

Also, the number of lines is small.
Current working one without the code to parse mount option(just hard 
coded for testing yet) only adds about 780 lines to do dedup.

On the other hand the cost is obvious too, not every duplicated page 
will be deduplicated, and still can't solve the space waste problem.

But IMHO such implement can be improved further easily:
TODO list:
1. merge duplicated extent into larger one if possible.
For example:
Existing File 1:
0	4K	8K	12K
|AAAAAAA|BBBBBBB|CCCCCCC|

|<------Extent A------->|
New write into file2:
Current:
|AAAAAAA|BBBBBBB|
|-ExtB--|-ExtC--|

Ext B will point to extent A with offset 0, nr 4096.
Ext C will point to extent A with offset 4096, nr 4096.

TODO version:
|AAAAAAA|BBBBBBB|
|-----ExtD------|
Ext D will point to extent A with offset 0, nr 8192.

This will both reduce space waste and metadata size.
But like the implement itself, such behavior won't always do it best, 
and may fallback to the old one.

2. Persist dedup hash<->extent map.
As we already have the dedup ioctl number, in this implement, we can use 
it to pin a dedup hash mapping into memory and out of the LRU control.
This could hugely improve the flexibility of kernel inband dedup, and 
put the dedup policy out of kernel, making application handle things 
better than kernel.


>
> On a heavily defragmented filesystem the data copy required could be a
> little under 2GB for a single pair of cloned ranges (in the worst case
> of 4K cloned in two maximum-sized extents).  Currently FILE_EXTENT_SAME
> refuses to do work involving more than 32MB of reads for a single
> extent pair.  There's a pretty big gap between 32MB of reads and 4GB of
> reads _and_ writes.  FILE_EXTENT_SAME also takes a vector of extents,
> which multiply the work.
So breaking large extent is always needed, even in my implement, I limit 
the largest uncompressed extent to be 512K
(For 4K page size, 512K needs 128 hashes, at each takes 32bytes, hash 
will be just 1 page).

Thanks,
Qu
>
> It would be better if the kernel could manipulate the metadata directly to
> split extents.  Dedup does work now with copies, but quite inefficiently.
>
>> Thanks,
>>
>> -liubo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
