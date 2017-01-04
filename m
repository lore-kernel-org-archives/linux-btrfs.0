Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35435 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdADM7u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 07:59:50 -0500
Received: by mail-it0-f65.google.com with SMTP id b123so53992104itb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jan 2017 04:59:00 -0800 (PST)
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Peter Becker <floyd.net@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
 <CAEtw4r3mUA_4vcS-dbxagQn3NPRh8Cxcz0iF0L7jHwv5c9Ui+g@mail.gmail.com>
 <7b0c897f-844c-e7f4-0ce7-c9f888b95983@gmail.com>
 <CAEtw4r3rnKvBgz4BqiVYDz2Ru9RdXODyJOp0sYSiuNNh1Gbebg@mail.gmail.com>
 <dd94bb02-822b-2244-a326-c75a50c4429e@gmail.com>
 <CAEtw4r3+=TgehTqssEfb6WEU1Vu8DN6QHqJgOu5ik_bJG_dZ_A@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e36f11c8-9a55-fc82-67df-b45bb6aefb8b@gmail.com>
Date: Wed, 4 Jan 2017 07:58:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAEtw4r3+=TgehTqssEfb6WEU1Vu8DN6QHqJgOu5ik_bJG_dZ_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-03 16:35, Peter Becker wrote:
> As i understand the duperemove source-code right (i work on/ try to
> improve this code since 5 or 6 weeks on multiple parts), duperemove
> does hashing and calculation before they call extend_same.
> Duperemove stores all in a hashfile and read this. after all files
> hashed, and duplicates detected, the progress all in order without
> reading new data form disk / hashfile. so the byte-by-byte comparison
> of extend_same ioctl should consume the full possible bandwidth of the
> disks.
Not necessarily.  You've actually got a significant amount of processing 
between each disk operation.  General ordering inside the ioctl is:
1. Do generic ioctl setup.
2. Lock the extents.
3. Read the ranges into memory.
4. Compare the ranges.
5. If the ranges are identical, write out the changes needed to reflink 
them.
6. Unlock all the extents.
7. Do generic ioctl cleanup.
1 and 7 in particular are pretty heavy.  Ioctls were not intended to be 
called with this kind of frequency, and that fact really shows in the 
setup and teardown (overhead is way higher than a syscall).  The 
operation ended up being an ioctl instead of a syscall (or extension to 
another syscall) because:
1. Manipulating low-level filesystem state is part of what they're 
intended to be used for.
2. Introducing a new FS specific ioctl is a whole lot less controversial 
than introducing a new FS specific syscall.
>
> 1. dbfile_load_hashes
> 2. find_all_dupes
> 3. dedupe_results
> -> call the following in N threads:
>> dedupe_extent_list
>>> list_for_each_entry
>>>> add_extent_to_dedupe #produce a simple list/queue
>>>> dedupe_extents
>>>>> btrfs_extent_same
>>>>>> BTRFS_IOC_FILE_EXTENT_SAME
>
> So if this right, one of this thinks is realy slow:
>
> 1. byte-per-byte comparison
There's no way that this part can't be slow.  You need to load the data 
into the registers to do the comparison, you can't just point something 
at RAM and get an answer.  On x86, this in turn means that the 
comparison amounts to a loop of 2 loads followed by a compare and a 
branch for , repeated once for each range beyond the first, and that's 
assuming that the compiler optimizes it to the greatest degree possible. 
  On some other systems the compare and branch are one instruction, on 
others the second load might be eliminated, but overall it's not 
something that can be sped up all that much.
> 2. sets up the reflinks
This actually is not as efficient as it sounds like it should be, adding 
reflinks means updating metadata, which means that there is some 
unavoidable overhead here.  I doubt that it's where the issue is, but I 
may be wrong.
> 3. unlocks the new extent
There's one other aspect not listed here, locking the original extents, 
which can actually add quite a lot of overhead if the files are actually 
being used.
>
> If i'm not wrong with my understanding of the duperemove source code,
> this behaivor should also affected the online dedupe feature on with
> Qu Wenruo works.
AFAIK, that uses a different code path from the batch deduplication 
ioctl.  It also doesn't have the context switches and other overhead 
from an ioctl involved, because it's done in kernel code.
>
> 2017-01-03 21:40 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>> On 2017-01-03 15:20, Peter Becker wrote:
>>>
>>> I think i understand. The resulting keyquestion is, how i can improve
>>> the performance of extend_same ioctl.
>>> I tested it with following results:
>>>
>>> enviorment:
>>> 2 files, called "file", size each 100GB, duperemove nofiemap-options
>>> set, 1MB extend size.
>>>
>>> duperemove output:
>>> [0x1908590] (13889/72654) Try to dedupe extents with id d1c672db
>>> [0x1908590] Add extent for file "/mnt/new/file" at offset 66.7G (6)
>>> [0x1908590] Add extent for file "/mnt/old/file" at offset 66.9G (7)
>>> [0x1908590] Dedupe 1 extents (id: d1c672db) with target: (66.7G,
>>> 1.0M), "/mnt/new/file"
>>>
>>> iotop output for a 30 sec. sample
>>>
>>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>>                22,31    0,00   13,83        33,81    0,00       30,05
>>>
>>> Device:         rrqm/s   wrqm/s     r/s            w/s    rkB/s
>>> wkB/s    avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>>> sdd               0,00     1,70          1149,93    0,73  4600,53
>>> 139,60    8,24       0,23          0,20    0,19   13,64      0,19
>>> 21,84
>>> sde               0,00     0,00          1149,33    0,53  4597,33
>>> 23,87     8,04       0,20          0,18    0,18    1,75       0,18
>>> 20,47
>>> sdf                0,00     1,70          1149,60    0,63  4598,40
>>> 139,60    8,24       0,21          0,18    0,18    4,63       0,18
>>> 20,63
>>> sdh               0,00     0,00          1149,33    0,53  4597,33
>>> 23,87     8,04       0,21          0,18    0,18    4,25       0,18
>>> 20,85
>>>
>>> resulting in less then 18MB/s read. realy slow.
>>>
>>> Querstion 1: why, so slow?
>>
>> For a couple of reasons.  First, you have to understand that duperemove
>> itself actually does a pretty large amount of processing outside of the call
>> to the ioctl.  It first hashes the blocks for quicker comparison and
>> matching, then figures out which blocks match, and finally calls the ioctl
>> on the resulting matches.  The reason for this behavior is that the ioctl is
>> insanely slow.  It first locks the ranges passed in (so they don't get
>> changed by anything else during the deduplication process), then does a
>> byte-by-byte comparison to make sure they all actually do match (data
>> safety, I've said at least once before that I think there should be a flag
>> for the ioctl (or a separate ioctl) to skip this and assume that userspace
>> really knows what it's doing), then finally sets up the reflinks, and
>> unlocks the new extent.
>>
>> All of this ties into why I keep telling people that efficient deduplication
>> requires a tool that understands how the data being deduplicated is
>> structured.  By avoiding the need to hash and compare every block of data,
>> you can significantly improve the time that part takes, and quite often this
>> will mitigate the impact of getting a few false positives passed into the
>> ioctl.
>>>
>>> Questiont 2a: would be a higher extend-size perform better?
>>> Querstion 2b: or did i understand something wrong?
>>
>> No, a larger extent would probably not help much, and that's actually a
>> really good performance sample you've created.
>>
>> The block size does end up being somewhat of a trade-off.  Ideally, you want
>> it matched to the smallest possible chunk of duplicate data greater than or
>> equal to the filesystem block size for maximal space efficiency.  Doing this
>> however makes the extra processing done by duperemove take exponentially
>> longer because it has to calculate hashes for more blocks (this has very low
>> impact until you get to very small block sizes), and has to make
>> exponentially more comparisons (this has a very big impact as you shrink the
>> block size, just halving the block size will roughly quadruple the time it
>> takes to make the comparisons).
>>
>>>
>>> 2017-01-03 20:37 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>>>>
>>>> On 2017-01-03 14:21, Peter Becker wrote:
>>>>>
>>>>>
>>>>> All invocations are justified, but not relevant in (offline) backup
>>>>> and archive scenarios.
>>>>>
>>>>> For example you have multiple version of append-only log-files or
>>>>> append-only db-files (each more then 100GB in size), like this:
>>>>>
>>>>>> Snapshot_01_01_2017
>>>>>
>>>>>
>>>>> -> file1.log .. 201 GB
>>>>>
>>>>>> Snapshot_02_01_2017
>>>>>
>>>>>
>>>>> -> file1.log .. 205 GB
>>>>>
>>>>>> Snapshot_03_01_2017
>>>>>
>>>>>
>>>>> -> file1.log .. 221 GB
>>>>>
>>>>> The first 201 GB would be every time the same.
>>>>> Files a copied at night from windows, linux or bsd systems and
>>>>> snapshoted after copy.
>>>>>
>>>>> So a fast way to dedupe this is needed. Using 128KB blocks would
>>>>> result in 1646592 extends per Snapshot. 1MB blocksize results in
>>>>> 205.824 extends (not bad, but still terrible speed).
>>>>> I will test it at night with a patched version of duperemove with
>>>>> 100MB blocksize, but I have no hope that the throughput increases
>>>>> thereby.
>>>>
>>>>
>>>> Deduplication is not a general purpose thing (usually you have very
>>>> specifically structured data), but duperemove is supposed to be a general
>>>> purpose tool.  It works fine for two of the most common cases
>>>> (deduplicating
>>>> large numbers of small files or small numbers of large files), but it is
>>>> sub-optimal for those cases, and will be for almost any other case.  This
>>>> is
>>>> a canonical example though of a case where you can use a custom script or
>>>> program to figure out what's duplicated and then have that just call the
>>>> ioctl as appropriate itself.  Most cases where you are storing some kind
>>>> of
>>>> well structured data fall into this category.  In fact, both of the cases
>>>> where I use deduplication myself fall into such a category.  One case
>>>> involves multiple directories that are partial copies of a larger tree
>>>> which
>>>> are kept in sync with the larger tree and each other.  In that particular
>>>> case, I care about whole file deduplication, so I have a script that just
>>>> matches on path relative to the roots of each copy and the master copy,
>>>> verifies that the mtime and size are the same, and if so calls the ioctl
>>>> for
>>>> deduplication (with some fancy processing to fit within the max size
>>>> supported by the ioctl and prevent tiny tail extents).  The other case is
>>>> a
>>>> set of archives with a pretty solid fixed structure to them.  In that
>>>> case,
>>>> I have a different script that knows enough about the file structure to
>>>> know
>>>> where to look for duplicate blocks, thus avoiding having to hash the
>>>> whole
>>>> files.
>>>>
>>>> The append-only log/database case fits this type of thing perfectly, for
>>>> each subsequent file, you know already that (most of) the file up to the
>>>> length of the previous file is duplicated, so you can just split that
>>>> however you want into chunks and pass those to the dedupe ioctl and free
>>>> up
>>>> most of the space that would be used by the new file.  You can then run
>>>> duperemove with a hash-file to process any new blocks beyond the point
>>>> you
>>>> deduplicated up to to reclaim any excess space (currently this will
>>>> process
>>>> the whole file, but it should see that most of it is deduplicated
>>>> already).
>>>>
>>>>>
>>>>> For backup and archive scenarios the checksum-feature and the
>>>>> dub-data/metadata-feature of btrfs is realy nice. In particular if one
>>>>> considers the 7 years legally prescribed storage time.
>>>>>
>>>>> 2017-01-03 13:40 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>>>>>>
>>>>>>
>>>>>> On 2016-12-30 15:28, Peter Becker wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Hello, i have a 8 TB volume with multiple files with hundreds of GB
>>>>>>> each.
>>>>>>> I try to dedupe this because the first hundred GB of many files are
>>>>>>> identical.
>>>>>>> With 128KB blocksize with nofiemap and lookup-extends=no option, will
>>>>>>> take more then a week (only dedupe, previously hashed). So i tryed -b
>>>>>>> 100M but this returned me an error: "Blocksize is bounded ...".
>>>>>>>
>>>>>>> The reason is that the blocksize is limit to
>>>>>>>
>>>>>>> #define MAX_BLOCKSIZE (1024U*1024)
>>>>>>>
>>>>>>> But i can't found any description why.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Beyond what Xin mentioned (namely that 1MB is a much larger block than
>>>>>> will
>>>>>> be duplicated in most data-sets), there are a couple of other reasons:
>>>>>> 1. Smaller blocks will actually get you better deduplication on average
>>>>>> because they're more likely to match.  As an example, assume you have 2
>>>>>> files with the same 8 4k blocks in different orders:
>>>>>>   FileA: 1 2 3 4 5 6 7 8
>>>>>>   FileB: 7 8 5 6 3 4 1 2
>>>>>> In such a case, deduplicating at any block size above 8k would result
>>>>>> in
>>>>>> zero deduplication between these files, while 8k or less would
>>>>>> completely
>>>>>> deduplicate them.  This is of course a highly specific and somewhat
>>>>>> contrived example (in most cases it will be scattered duplicate blocks
>>>>>> over
>>>>>> dozens of files), but it does convey this specific point.
>>>>>> 2. The kernel will do a byte-wise comparison of all ranges you pass
>>>>>> into
>>>>>> the
>>>>>> ioctl at the same time.  Larger block sizes here mean that:
>>>>>>         a) The extents will be locked longer, which will prevent any
>>>>>> I/O
>>>>>> to
>>>>>> the files being deduplicated for the duration of the comparison, which
>>>>>> may
>>>>>> in turn cause other issues on the system.
>>>>>>         b) The deduplication process will be stuck in uninterruptible
>>>>>> sleep
>>>>>> longer, which on many systems will trigger hung task detection, which
>>>>>> will
>>>>>> in turn either spam the system log or panic the system depending on how
>>>>>> it's
>>>>>> configured.
>>>>>>
>>>>
>>

