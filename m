Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdIKFXE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 01:23:04 -0400
Subject: Re: Regarding handling of file renames in Btrfs
To: Martin Raiber <martin@urbackup.org>,
        Rohan Kadekodi <kadekodirohan@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
 <571bed07-1525-0115-358c-23d98104c907@gmx.com>
 <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
 <0102015e6c3664dc-9943256b-8e87-487e-807b-65f2dd7c7556-000000@eu-west-1.amazonses.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d8c737bc-6a20-6b5a-8e8f-058b75445de4@gmx.com>
Date: Mon, 11 Sep 2017 13:22:35 +0800
MIME-Version: 1.0
In-Reply-To: <0102015e6c3664dc-9943256b-8e87-487e-807b-65f2dd7c7556-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月10日 22:34, Martin Raiber wrote:
> Hi,
> 
> On 10.09.2017 08:45 Qu Wenruo wrote:
>>
>>
>> On 2017年09月10日 14:41, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年09月10日 07:50, Rohan Kadekodi wrote:
>>>> Hello,
>>>>
>>>> I was trying to understand how file renames are handled in Btrfs. I
>>>> read the code documentation, but had a problem understanding a few
>>>> things.
>>>>
>>>> During a file rename, btrfs_commit_transaction() is called which is
>>>> because Btrfs has to commit the whole FS before storing the
>>>> information related to the new renamed file. It has to commit the FS
>>>> because a rename first does an unlink, which is not recorded in the
>>>> btrfs_rename() transaction and so is not logged in the log tree. Is my
>>>> understanding correct? If yes, my questions are as follows:
>>>
>>> Not familiar with rename kernel code, so not much help for rename
>>> opeartion.
>>>
>>>>
>>>> 1. What does committing the whole FS mean?
>>>
>>> Committing the whole fs means a lot of things, but generally
>>> speaking, it makes that the on-disk data is inconsistent with each
>>> other.
>>
>>> For obvious part, it writes modified fs/subvolume trees to disk (with
>>> handling of tree operations so no half modified trees).
>>>
>>> Also other trees like extent tree (very hot since every CoW will
>>> update it, and the most complicated one), csum tree if modified.
>>>
>>> After transaction is committed, the on-disk btrfs will represent the
>>> states when commit trans is called, and every tree should match each
>>> other.
>>>
>>> Despite of this, after a transaction is committed, generation of the
>>> fs get increased and modified tree blocks will have the same
>>> generation number.
>>>
>>>> Blktrace shows that there
>>>> are 2       256KB writes, which are essentially writes to the data of
>>>> the root directory of the file system (which I found out through
>>>> btrfs-debug-tree).
>>>
>>> I'd say you didn't check btrfs-debug-tree output carefully enough.
>>> I strongly recommend to do vimdiff to get what tree is modified.
>>>
>>> At least the following trees are modified:
>>>
>>> 1) fs/subvolume tree
>>>      Rename modified the DIR_INDEX/DIR_ITEM/INODE_REF at least, and
>>>      updated inode time.
>>>      So fs/subvolume tree must be CoWed.
>>>
>>> 2) extent tree
>>>      CoW of above metadata operation will definitely cause extent
>>>      allocation and freeing, extent tree will also get updated.
>>>
>>> 3) root tree
>>>      Both extent tree and fs/subvolume tree modified, their root bytenr
>>>      needs to be updated and root tree must be updated.
>>>
>>> And finally superblocks.
>>>
>>> I just verified the behavior with empty btrfs created on a 1G file,
>>> only one file to do the rename.
>>>
>>> In that case (with 4K sectorsize and 16K nodesize), the total IO
>>> should be (3 * 16K) * 2 + 4K * 2 = 104K.
>>>
>>> "3" = number of tree blocks get modified
>>> "16K" = nodesize
>>> 1st "*2" = DUP profile for metadata
>>> "4K" = superblock size
>>> 2nd "*2" = 2 superblocks for 1G fs.
>>>
>>> If your extent/root/fs trees have higher level, then more tree blocks
>>> needs to be updated.
>>> And if your fs is very large, you may have 3 superblocks.
>>>
>>>> Is this equivalent to doing a shell sync, as the
>>>> same block groups are written during a shell sync too?
>>>
>>> For shell "sync" the difference is that, "sync" will write all dirty
>>> data pages to disk, and then commit transaction.
>>> While only calling btrfs_commit_transacation() doesn't trigger dirty
>>> page writeback.
>>>
>>> So there is a difference.
> 
> this conversation made me realize why btrfs has sub-optimal meta-data
> performance. Cow b-trees are not the best data structure for such small
> changes. In my application I have multiple operations (e.g. renames)
> which can be bundles up and (mostly) one writer.

Things are more complicated in fact.

For example, even you are only renaming/moving one file.
But in fact you're going to at least modify 6 items, they are:

1) Removing DIR_INDEX of original parent dir inode
    Assume the original parent dir inode number is 300.
    We are removing (300 DIR_INDEX <seq>).

2) Removing DIR_ITEM of original parent dir inode
    We are removing (300 DIR_ITEM <crc32 of the old filename>)

3) Removing INODE_REF of the renamed inode
    Assume the renamed inode number is 400
    We are removing (400 INODE_REF 300).

4) Adding new DIR_INDEX to new parent dir inode
    Assume the new parent dir inode number is 500.
    We are adding (500 DIR_INDEX <seq>)

5) Adding new DIR_ITEM to new parent dir inode
    We are adding (500 DIR_ITEM <crc32 of the new filename>)

6) Adding new INODE_REF to renamed inode
    We are adding (400 INODE_REF 500)

As you can see, there are 6 keys modification, and we can't ensure they 
are all in one leaf.
In worst case, we need to CoW the tree 6 times for different leaves.
(Although CoWed tree won't be CoWed again until written to disk, which 
reduces overhead)

And even more, if you modified one tree, you must also modify the 
ROOT_ITEM pointing the tree, which leads to root tree CoW.


I have a crazy idea to double buffering tree blocks.
That's to say, one tree block is actually consisted of 2 real tree blocks.

And when CoW happens, just switch to the other tree block.
So that we don't really need to update its parent pointer, so we can 
limit the CoW affected range to minimal.

But it's trading space for IO (although metadata space is relatively 
small), and it will definitely cause LARGE on-disk format change.

> I guess using BTRFS_IOC_TRANS_START and BTRFS_IOC_TRANS_END would be one
> way to reduce the cow overhead, but those are dangerous wrt. to ENOSPC
> and there have been discussions about removing them.

Nope. in current Btrfs behavior, only longer transaction can reduce 
overhead.
As already CoWed and unwritten tree block will not be CoWed again, but 
just modified in memory.

So you should try to avoid such ioctl and let btrfs to handle 
transaction by itself.

> Best would be if there were delayed metadata, where metadata is handled
> the same as delayed allocations and data changes, i.e. commit on fsync,
> commit interval or fssync. I assumed this was already the case...

Already delayed, as CoWed but not written tree block will not be CoWed 
again.

And we even have double delay for extent tree update to improve performance.

But don't forget that such *optimization* itself is trading robust for 
performance.
(More code always means more bugs, and delayed-ref for extent tree is 
already bug-prone)

Thanks,
Qu

> 
> Please correct me if I got this wrong.
> 
> Regards,
> Martin Raiber
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
