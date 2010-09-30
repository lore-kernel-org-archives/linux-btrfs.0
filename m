From: David Brown <david@westcontrol.com>
Subject: Re: BTRFS && SSD
Date: Thu, 30 Sep 2010 09:51:47 +0200
Message-ID: <i81fip$9qg$1@dough.gmane.org>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com>	<20100929170855.GA4635@lelouch.nomadic.ncsu.edu>	<AANLkTind3szR8RjBLPbKb2yMH-s8q2ti+28N38z1BeTj@mail.gmail.com>	<20100929195929.GA5588@lelouch.nomadic.ncsu.edu> <AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinzhHOv4L0cPR+tiw=3b7koHGe7svX223FNSxxS@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 29/09/2010 23:31, Yuehai Xu wrote:
> On Wed, Sep 29, 2010 at 3:59 PM, Sean Bartell<wingedtachikoma@gmail.com>  wrote:
>> On Wed, Sep 29, 2010 at 02:45:29PM -0400, Yuehai Xu wrote:
>>> On Wed, Sep 29, 2010 at 1:08 PM, Sean Bartell<wingedtachikoma@gmail.com>  wrote:
>>>> On Wed, Sep 29, 2010 at 11:30:14AM -0400, Yuehai Xu wrote:
>>>>> I know BTRFS is a kind of Log-structured File System, which doesn't do
>>>>> overwrite. Here is my question, suppose file A is overwritten by A',
>>>>> instead of writing A' to the original place of A, a new place is
>>>>> selected to store it. However, we know that the address of a file
>>>>> should be recorded in its inode. In such case, the corresponding part
>>>>> in inode of A should update from the original place A to the new place
>>>>> A', is this a kind of overwrite actually? I think no matter what
>>>>> design it is for Log-Structured FS, a mapping table is always needed,
>>>>> such as inode map, DAT, etc. When a update operation happens for this
>>>>> mapping table, is it actually a kind of over-write? If it is, is it a
>>>>> bottleneck for the performance of write for SSD?
>>>>
>>>> In btrfs, this is solved by doing the same thing for the inode--a new
>>>> place for the leaf holding the inode is chosen. Then the parent of the
>>>> leaf must point to the new position of the leaf, so the parent is moved,
>>>> and the parent's parent, etc. This goes all the way up to the
>>>> superblocks, which are actually overwritten one at a time.
>>>
>>> You mean that there is no over-write for inode too, once the inode
>>> need to be updated, this inode is actually written to a new place
>>> while the only thing to do is to change the point of its parent to
>>> this new place. However, for the last parent, or the superblock, does
>>> it need to be overwritten?
>>
>> Yes. The idea of copy-on-write, as used by btrfs, is that whenever
>> *anything* is changed, it is simply written to a new location. This
>> applies to data, inodes, and all of the B-trees used by the filesystem.
>> However, it's necessary to have *something* in a fixed place on disk
>> pointing to everything else. So the superblocks can't move, and they are
>> overwritten instead.
>>
>
> So, is it a bottleneck in the case of SSD since the cost for over
> write is very high? For every write, I think the superblocks should be
> overwritten, it might be much more frequent than other common blocks
> in SSD, even though SSD will do wear leveling inside by its FTL.
>

SSDs already do copy-on-write.  They can't change small parts of the 
data in a block, but have to re-write the block.  While that could be 
done by reading the whole erase block to a ram buffer, changing the 
data, erasing the flash block, then re-writing, this is not what happens 
in practice.  To make efficient use of write blocks that are smaller 
than erase blocks, and to provide wear levelling, the flash disk will 
implement a small change to a block by writing a new copy of the 
modified block to a different part of the flash, then updating its block 
indirection tables.

BTRFS just makes this process a bit more explicit (except for superblock 
writes).

> What I current know is that for Intel x25-V SSD, the write throughput
> of BTRFS is almost 80% less than the one of EXT3 in the case of
> PostMark. This really confuses me.
>

Different file systems have different strengths and weaknesses.  I 
haven't actually tested BTRFS much, but my understanding is that it will 
be significantly slower than EXT in certain cases, such as small 
modifications to large files (since copy-on-write means a lot of extra 
disk activity in such cases).  But for other things it is faster.  Also 
remember that BTRFS is under development - optimising for raw speed 
comes at a lower priority than correctness and safety of data, and 
implementation of BTRFS features.  Once everyone is happy with the 
stability of the file system and its functionality and tools, you can 
expect the speed to improve somewhat over time.

