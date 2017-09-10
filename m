Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-1.smtp-out.eu-west-1.amazonses.com ([54.240.4.1]:56980 "EHLO
        a4-1.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751599AbdIJOeU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 10:34:20 -0400
Subject: Re: Regarding handling of file renames in Btrfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Rohan Kadekodi <kadekodirohan@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
 <571bed07-1525-0115-358c-23d98104c907@gmx.com>
 <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015e6c3664dc-9943256b-8e87-487e-807b-65f2dd7c7556-000000@eu-west-1.amazonses.com>
Date: Sun, 10 Sep 2017 14:34:17 +0000
MIME-Version: 1.0
In-Reply-To: <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 10.09.2017 08:45 Qu Wenruo wrote:
>
>
> On 2017年09月10日 14:41, Qu Wenruo wrote:
>>
>>
>> On 2017年09月10日 07:50, Rohan Kadekodi wrote:
>>> Hello,
>>>
>>> I was trying to understand how file renames are handled in Btrfs. I
>>> read the code documentation, but had a problem understanding a few
>>> things.
>>>
>>> During a file rename, btrfs_commit_transaction() is called which is
>>> because Btrfs has to commit the whole FS before storing the
>>> information related to the new renamed file. It has to commit the FS
>>> because a rename first does an unlink, which is not recorded in the
>>> btrfs_rename() transaction and so is not logged in the log tree. Is my
>>> understanding correct? If yes, my questions are as follows:
>>
>> Not familiar with rename kernel code, so not much help for rename
>> opeartion.
>>
>>>
>>> 1. What does committing the whole FS mean?
>>
>> Committing the whole fs means a lot of things, but generally
>> speaking, it makes that the on-disk data is inconsistent with each
>> other.
>
>> For obvious part, it writes modified fs/subvolume trees to disk (with
>> handling of tree operations so no half modified trees).
>>
>> Also other trees like extent tree (very hot since every CoW will
>> update it, and the most complicated one), csum tree if modified.
>>
>> After transaction is committed, the on-disk btrfs will represent the
>> states when commit trans is called, and every tree should match each
>> other.
>>
>> Despite of this, after a transaction is committed, generation of the
>> fs get increased and modified tree blocks will have the same
>> generation number.
>>
>>> Blktrace shows that there
>>> are 2       256KB writes, which are essentially writes to the data of
>>> the root directory of the file system (which I found out through
>>> btrfs-debug-tree).
>>
>> I'd say you didn't check btrfs-debug-tree output carefully enough.
>> I strongly recommend to do vimdiff to get what tree is modified.
>>
>> At least the following trees are modified:
>>
>> 1) fs/subvolume tree
>>     Rename modified the DIR_INDEX/DIR_ITEM/INODE_REF at least, and
>>     updated inode time.
>>     So fs/subvolume tree must be CoWed.
>>
>> 2) extent tree
>>     CoW of above metadata operation will definitely cause extent
>>     allocation and freeing, extent tree will also get updated.
>>
>> 3) root tree
>>     Both extent tree and fs/subvolume tree modified, their root bytenr
>>     needs to be updated and root tree must be updated.
>>
>> And finally superblocks.
>>
>> I just verified the behavior with empty btrfs created on a 1G file,
>> only one file to do the rename.
>>
>> In that case (with 4K sectorsize and 16K nodesize), the total IO
>> should be (3 * 16K) * 2 + 4K * 2 = 104K.
>>
>> "3" = number of tree blocks get modified
>> "16K" = nodesize
>> 1st "*2" = DUP profile for metadata
>> "4K" = superblock size
>> 2nd "*2" = 2 superblocks for 1G fs.
>>
>> If your extent/root/fs trees have higher level, then more tree blocks
>> needs to be updated.
>> And if your fs is very large, you may have 3 superblocks.
>>
>>> Is this equivalent to doing a shell sync, as the
>>> same block groups are written during a shell sync too?
>>
>> For shell "sync" the difference is that, "sync" will write all dirty
>> data pages to disk, and then commit transaction.
>> While only calling btrfs_commit_transacation() doesn't trigger dirty
>> page writeback.
>>
>> So there is a difference.

this conversation made me realize why btrfs has sub-optimal meta-data
performance. Cow b-trees are not the best data structure for such small
changes. In my application I have multiple operations (e.g. renames)
which can be bundles up and (mostly) one writer.
I guess using BTRFS_IOC_TRANS_START and BTRFS_IOC_TRANS_END would be one
way to reduce the cow overhead, but those are dangerous wrt. to ENOSPC
and there have been discussions about removing them.
Best would be if there were delayed metadata, where metadata is handled
the same as delayed allocations and data changes, i.e. commit on fsync,
commit interval or fssync. I assumed this was already the case...

Please correct me if I got this wrong.

Regards,
Martin Raiber
