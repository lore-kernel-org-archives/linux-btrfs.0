From: Yuehai Xu <yuehaixu@gmail.com>
Subject: Re: BTRFS && SSD
Date: Thu, 30 Sep 2010 08:04:01 -0400
Message-ID: <AANLkTikqqKzbQBhSffwHzW1hkUf8g4ROFcgJ46i3jiid@mail.gmail.com>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>
	<20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
	<AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>
	<20100929195929.GA5588@lelouch.nomadic.ncsu.edu>
	<AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
	<i81fip$9qg$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, yhxu@wayne.edu
To: David Brown <david@westcontrol.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i81fip$9qg$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 30, 2010 at 3:51 AM, David Brown <david@westcontrol.com> wr=
ote:
> On 29/09/2010 23:31, Yuehai Xu wrote:
>>
>> On Wed, Sep 29, 2010 at 3:59 PM, Sean Bartell<wingedtachikoma@gmail.=
com>
>> =A0wrote:
>>>
>>> On Wed, Sep 29, 2010 at 02:45:29PM -0400, Yuehai Xu wrote:
>>>>
>>>> On Wed, Sep 29, 2010 at 1:08 PM, Sean Bartell<wingedtachikoma@gmai=
l.com>
>>>> =A0wrote:
>>>>>
>>>>> On Wed, Sep 29, 2010 at 11:30:14AM -0400, Yuehai Xu wrote:
>>>>>>
>>>>>> I know BTRFS is a kind of Log-structured File System, which does=
n't do
>>>>>> overwrite. Here is my question, suppose file A is overwritten by=
 A',
>>>>>> instead of writing A' to the original place of A, a new place is
>>>>>> selected to store it. However, we know that the address of a fil=
e
>>>>>> should be recorded in its inode. In such case, the corresponding=
 part
>>>>>> in inode of A should update from the original place A to the new=
 place
>>>>>> A', is this a kind of overwrite actually? I think no matter what
>>>>>> design it is for Log-Structured FS, a mapping table is always ne=
eded,
>>>>>> such as inode map, DAT, etc. When a update operation happens for=
 this
>>>>>> mapping table, is it actually a kind of over-write? If it is, is=
 it a
>>>>>> bottleneck for the performance of write for SSD?
>>>>>
>>>>> In btrfs, this is solved by doing the same thing for the inode--a=
 new
>>>>> place for the leaf holding the inode is chosen. Then the parent o=
f the
>>>>> leaf must point to the new position of the leaf, so the parent is
>>>>> moved,
>>>>> and the parent's parent, etc. This goes all the way up to the
>>>>> superblocks, which are actually overwritten one at a time.
>>>>
>>>> You mean that there is no over-write for inode too, once the inode
>>>> need to be updated, this inode is actually written to a new place
>>>> while the only thing to do is to change the point of its parent to
>>>> this new place. However, for the last parent, or the superblock, d=
oes
>>>> it need to be overwritten?
>>>
>>> Yes. The idea of copy-on-write, as used by btrfs, is that whenever
>>> *anything* is changed, it is simply written to a new location. This
>>> applies to data, inodes, and all of the B-trees used by the filesys=
tem.
>>> However, it's necessary to have *something* in a fixed place on dis=
k
>>> pointing to everything else. So the superblocks can't move, and the=
y are
>>> overwritten instead.
>>>
>>
>> So, is it a bottleneck in the case of SSD since the cost for over
>> write is very high? For every write, I think the superblocks should =
be
>> overwritten, it might be much more frequent than other common blocks
>> in SSD, even though SSD will do wear leveling inside by its FTL.
>>
>
> SSDs already do copy-on-write. =A0They can't change small parts of th=
e data in
> a block, but have to re-write the block. =A0While that could be done =
by
> reading the whole erase block to a ram buffer, changing the data, era=
sing
> the flash block, then re-writing, this is not what happens in practic=
e. =A0To
> make efficient use of write blocks that are smaller than erase blocks=
, and
> to provide wear levelling, the flash disk will implement a small chan=
ge to a
> block by writing a new copy of the modified block to a different part=
 of the
> flash, then updating its block indirection tables.

Yes, the FTL inside the SSDs will do such kind of job, and the
overhead should be small once the block mapping is page-level mapping,
however, the size of page-level mapping is too large to be stored
totally in the SRAM of SSDs, So, many complicated algorithms have been
developed to optimize this. In another word, SSDs might not always be
smart enough to do wear leveling with small overhead. This is my
subjective opinion.

>
> BTRFS just makes this process a bit more explicit (except for superbl=
ock
> writes).

As you have said, the superblocks should be over written, is it
frequent? If it is, is it possible to be potential bottleneck for the
throughput of SSDs? Afterall, SSDs are not happy with over-write. Of
course, few people really knows what's the algorithms really are for
the FTL, which determines the efficiency of SSDs actually.


>
>> What I current know is that for Intel x25-V SSD, the write throughpu=
t
>> of BTRFS is almost 80% less than the one of EXT3 in the case of
>> PostMark. This really confuses me.
>>
>
> Different file systems have different strengths and weaknesses. =A0I =
haven't
> actually tested BTRFS much, but my understanding is that it will be
> significantly slower than EXT in certain cases, such as small modific=
ations
> to large files (since copy-on-write means a lot of extra disk activit=
y in
> such cases). =A0But for other things it is faster. =A0Also remember t=
hat BTRFS
> is under development - optimising for raw speed comes at a lower prio=
rity
> than correctness and safety of data, and implementation of BTRFS feat=
ures.
> =A0Once everyone is happy with the stability of the file system and i=
ts
> functionality and tools, you can expect the speed to improve somewhat=
 over
> time.

My test case for PostMark is:
set file size 9216 15360 (file size from 9216 bytes to 15360 bytes)
set number 50000(file number is 50000)

write throughput(MB/s) for different file systems in Intel SSD X25-V:
EXT3: 28.09
NILFS2: 10
BTRFS: 17.35
EXT4: 31.04
XFS: 11.56
REISERFS: 28.09
EXT2: 15.94

Thanks,
Yuehai

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
