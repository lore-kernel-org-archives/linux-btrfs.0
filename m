Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34895 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdIJOcM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 10:32:12 -0400
Received: by mail-io0-f176.google.com with SMTP id i14so13355150ioe.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 07:32:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
 <571bed07-1525-0115-358c-23d98104c907@gmx.com> <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
From: Rohan Kadekodi <kadekodirohan@gmail.com>
Date: Sun, 10 Sep 2017 09:32:10 -0500
Message-ID: <CADb0YNm4QznnizSCeCY15qsoj=dVistJ7pZETca9CnYasgLJfg@mail.gmail.com>
Subject: Re: Regarding handling of file renames in Btrfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the prompt and elaborate answers! However, I think I was
unclear in my questions, and I apologize for the confusion.

What I meant was that for a file rename, when I check the blktrace
output, there are 2 writes of 256KB each starting from byte number:
13373440

When I check btrfs-debug-tree, I see that the following items are related to it:

1) root tree:
     key (256 EXTENT_DATA 0) itemoff 13649 itemsize 53
     extent data disk byte 13373440 nr 262144
     extent data offset 0 nr 262144 ram 262144
     extent compression 0

2) extent tree:
     key (13373440 EXTENT_ITEM 262144) itemoff 15040 itemsize 53
     extent refs 1 gen 12 flags DATA
     extent data backref root 1 objectid 256 offset 0 count 1

So this means that the extent allocated to the root folder (mount
point) is getting written twice right? Here I am not talking about any
metadata, but the data in the extent allocated to the root folder,
that is inode number 256.

When I was analyzing the code, I saw that these writes happened from
btrfs_start_dirty_block_groups() which is in
btrfs_commit_transaction(). This is the same thing that is getting
written on a filesystem commit.

So my questions were:
1) Why are there 2 256KB writes happening during a filesystem commit
to the same location instead of just 1? Also, what exactly is written
in the root folder of the file system? Again, I am talking about the
data held in the extent allocated inode 256 and not about any metadata
or any tree.

2) I understand by the on-disk format that all the child dir/inode
info in one subvolume are in the same tree, but these writes that I am
talking about are not to any tree, they to the data held in inode 256,
which happens to be the mount point. So by root directory, I mean the
mount point or the inode 256 (not any tree). And even though metadata
wise there is no hierarchy as such in the file system, each folder
data will only contain the data belonging to its children right? Hence
my question was that why does the data in the extent allocated to
inode 256 need to be rewritten instead of just the parent folder for a
rename?

Thanks,
Rohan

On 10 September 2017 at 01:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年09月10日 14:41, Qu Wenruo wrote:
>>
>>
>>
>> On 2017年09月10日 07:50, Rohan Kadekodi wrote:
>>>
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
>>
>> Not familiar with rename kernel code, so not much help for rename
>> opeartion.
>>
>>>
>>> 1. What does committing the whole FS mean?
>>
>>
>> Committing the whole fs means a lot of things, but generally speaking, it
>> makes that the on-disk data is inconsistent with each other.
>
>                                     ^consistent
> Sorry for the typo.
>
> Thanks,
> Qu
>
>>
>> For obvious part, it writes modified fs/subvolume trees to disk (with
>> handling of tree operations so no half modified trees).
>>
>> Also other trees like extent tree (very hot since every CoW will update
>> it, and the most complicated one), csum tree if modified.
>>
>> After transaction is committed, the on-disk btrfs will represent the
>> states when commit trans is called, and every tree should match each other.
>>
>> Despite of this, after a transaction is committed, generation of the fs
>> get increased and modified tree blocks will have the same generation number.
>>
>>> Blktrace shows that there
>>> are 2       256KB writes, which are essentially writes to the data of
>>> the root directory of the file system (which I found out through
>>> btrfs-debug-tree).
>>
>>
>> I'd say you didn't check btrfs-debug-tree output carefully enough.
>> I strongly recommend to do vimdiff to get what tree is modified.
>>
>> At least the following trees are modified:
>>
>> 1) fs/subvolume tree
>>     Rename modified the DIR_INDEX/DIR_ITEM/INODE_REF at least, and
>>     updated inode time.
>>     So fs/subvolume tree must be CoWed.
>>
>> 2) extent tree
>>     CoW of above metadata operation will definitely cause extent
>>     allocation and freeing, extent tree will also get updated.
>>
>> 3) root tree
>>     Both extent tree and fs/subvolume tree modified, their root bytenr
>>     needs to be updated and root tree must be updated.
>>
>> And finally superblocks.
>>
>> I just verified the behavior with empty btrfs created on a 1G file, only
>> one file to do the rename.
>>
>> In that case (with 4K sectorsize and 16K nodesize), the total IO should be
>> (3 * 16K) * 2 + 4K * 2 = 104K.
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
>>
>> For shell "sync" the difference is that, "sync" will write all dirty data
>> pages to disk, and then commit transaction.
>> While only calling btrfs_commit_transacation() doesn't trigger dirty page
>> writeback.
>>
>> So there is a difference.
>>
>> And furthermore, if there is nothing to modified at all, sync will just
>> skip the fs, so btrfs_commit_transaction() is not ensured if you call
>> "sync".
>>
>>> Also, does it
>>> imply that all the metadata held by the log tree is now checkpointed
>>> to the respective trees?
>>
>>
>> Log tree part is a little tricky, as the log tree is not really a journal
>> for btrfs.
>> Btrfs uses CoW for metadata so in theory (and in fact) btrfs doesn't need
>> any journal.
>>
>> Log tree is mainly used for enhancing btrfs fsync performance.
>> You can totally disable log tree by notreelog mount option and btrfs will
>> behave just fine.
>>
>> And furthermore, I'm not very familiar with log tree, I need to verify the
>> code to see if log tree is used in rename, so I can't say much right now.
>>
>> But to make things easy, I strongly recommend to ignore log tree for now.
>>
>>>
>>> 2. Why are there 2 complete writes to the data held by the root
>>> directory and not just 1? These writes are 256KB each, which is the
>>> size of the extent allocated to the root directory
>>
>>
>> Check my first calculation and verify the debug-tree output before and
>> after rename.
>>
>> I think there is some extra factors affecting the number, from the tree
>> height to your fs tree organization.
>>
>>>
>>> 3. Why are the writes being done to the root directory of the file
>>> system / subvolume and not just the parent directory where the unlink
>>> happened?
>>
>>
>> That's why I strongly recommend to understand btrfs on-disk format first.
>> A lot of things can be answered after understanding the on-disk layout,
>> without asking any other guys.
>>
>> The short answer is, btrfs puts all its child dir/inode info into one tree
>> for one subvolume.
>> (And the term "root directory" here is a little confusing, are you talking
>> about the fs tree root or the root tree?)
>>
>> Not the common one tree for one inode layout.
>>
>> So if you rename one file in a subvolume, the subvolume tree get CoWed,
>> which means from the leaf containing the key/item you want to modify, to the
>> tree root will be CoWed.
>>
>> Thanks,
>> Qu
>>>
>>>
>>> It would be great if I could get the answers to these questions.
>>>
>>> Thanks,
>>> Rohan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
