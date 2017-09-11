Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53568 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751942AbdIKBtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 21:49:25 -0400
Subject: Re: Regarding handling of file renames in Btrfs
To: Rohan Kadekodi <kadekodirohan@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
 <571bed07-1525-0115-358c-23d98104c907@gmx.com>
 <7adde771-3434-ca25-60a4-e9f1fdd4f671@gmx.com>
 <CADb0YNm4QznnizSCeCY15qsoj=dVistJ7pZETca9CnYasgLJfg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ef12583c-1f92-8c7d-8de6-c52e53421d52@gmx.com>
Date: Mon, 11 Sep 2017 09:48:59 +0800
MIME-Version: 1.0
In-Reply-To: <CADb0YNm4QznnizSCeCY15qsoj=dVistJ7pZETca9CnYasgLJfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月10日 22:32, Rohan Kadekodi wrote:
> Thank you for the prompt and elaborate answers! However, I think I was
> unclear in my questions, and I apologize for the confusion.
> 
> What I meant was that for a file rename, when I check the blktrace
> output, there are 2 writes of 256KB each starting from byte number:
> 13373440
> 
> When I check btrfs-debug-tree, I see that the following items are related to it:
> 
> 1) root tree:
>       key (256 EXTENT_DATA 0) itemoff 13649 itemsize 53
>       extent data disk byte 13373440 nr 262144
>       extent data offset 0 nr 262144 ram 262144
>       extent compression 0
> 
> 2) extent tree:
>       key (13373440 EXTENT_ITEM 262144) itemoff 15040 itemsize 53
>       extent refs 1 gen 12 flags DATA
>       extent data backref root 1 objectid 256 offset 0 count 1
> 
> So this means that the extent allocated to the root folder (mount
> point) is getting written twice right? Here I am not talking about any
> metadata, but the data in the extent allocated to the root folder,
> that is inode number 256.

Such extent data is used by free space cache.

If using nospace_cache or space_cache=v2 mount option, there will no 
such thing.

Free space cache is used for recording free and used space for each 
chunk (or block group, which is mostly the same thing).
Since CoW happens for metadata chunk, its used/free space mapping get 
modified and then free space cache will also be updated.

BTW, some term usage difference makes me a little confused.
Personally speaking, we call root 1 "tree root" or "root tree", not root 
directory.
As in fact such tree doesn't contain any real file/directory.
> 
> When I was analyzing the code, I saw that these writes happened from
> btrfs_start_dirty_block_groups() which is in
> btrfs_commit_transaction(). This is the same thing that is getting
> written on a filesystem commit.
> 
> So my questions were:
> 1) Why are there 2 256KB writes happening during a filesystem commit
> to the same location instead of just 1? Also, what exactly is written
> in the root folder of the file system? Again, I am talking about the
> data held in the extent allocated inode 256 and not about any metadata
> or any tree.

As stated above, EXTENT_DATA in root tree is for space cache (v1).
Which uses NoCOW file extent as file to record free space.

And such space cache is for each block group.

Furthermore, since it's EXTENT_DATA, it counts as DATA, so it follows 
your data profile (default to single for single device and RAID0 for 
multi device).

If not using DUP1 as data profile, then you have 2 block groups get 
modified.

> 
> 2) I understand by the on-disk format that all the child dir/inode
> info in one subvolume are in the same tree, but these writes that I am
> talking about are not to any tree, they to the data held in inode 256,
> which happens to be the mount point. So by root directory, I mean the
> mount point or the inode 256 (not any tree).

As mentioned before, it's better to call it "root tree" as it doesn't 
really represents a directory.

> And even though metadata
> wise there is no hierarchy as such in the file system, each folder
> data will only contain the data belonging to its children right?

The sentence is confusing to me now.
By "folder" did you mean normal directory? And how do you define "data 
belonging to its children"?

As stated before, there is no real boundary for an inode (including 
normal file and directory).
All inode data (including EXTENT_DATA for regular file and DIR_INDEX/DIR 
for directory inode) are just sequential keys (with its data) in a 
subvolume.

So without your definition of "belonging to" I can't get the point.

> Hence
> my question was that why does the data in the extent allocated to
> inode 256 need to be rewritten instead of just the parent folder for a
> rename?

My first paragraph explained this.

BTW, for your concerned EXTENT_DATA in root 1 (root tree), it's used by 
the following sequence: (BTRFS_ prefix omitted, all keys are in root 1)

(FREE_SPACE_OBJECTID, 0, <Block group bytenr>)
Its structure, btrfs_free_space_header, contains a key referring to an 
inode, which is a regular file inode.
The inode key will be (<ino>, INODE_ITEM, 0)

Then still in tree root (rootid 1), search using the (<ino>, INODE_ITEM, 
0) key, to locate the free space cache inode.

Finally btrfs will just read data stored for this inode.
Using its (<ino>, EXTENT_DATA, <offset>) to locate its real data on 
disk, and read it out.

For details like how the space cache looks like, you need to check the 
free space cache code then.
(And for short, it's a mess, so we have space_cache=v2, which uses 
normal btrfs Btree to store such info, and btrfs-debug-tree can show it 
easily)

And of course, for transaction commit, each dirty block group will need 
to update its free space cache, and its free space cache file has 
NODATACOW flag, so free space cache itself has some checksum mechanism, 
so normally the whole free space cache file is updated.

Thanks,
Qu

> 
> Thanks,
> Rohan
> 
> On 10 September 2017 at 01:45, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2017年09月10日 14:41, Qu Wenruo wrote:
>>>
>>>
>>>
>>> On 2017年09月10日 07:50, Rohan Kadekodi wrote:
>>>>
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
>>>
>>> Not familiar with rename kernel code, so not much help for rename
>>> opeartion.
>>>
>>>>
>>>> 1. What does committing the whole FS mean?
>>>
>>>
>>> Committing the whole fs means a lot of things, but generally speaking, it
>>> makes that the on-disk data is inconsistent with each other.
>>
>>                                      ^consistent
>> Sorry for the typo.
>>
>> Thanks,
>> Qu
>>
>>>
>>> For obvious part, it writes modified fs/subvolume trees to disk (with
>>> handling of tree operations so no half modified trees).
>>>
>>> Also other trees like extent tree (very hot since every CoW will update
>>> it, and the most complicated one), csum tree if modified.
>>>
>>> After transaction is committed, the on-disk btrfs will represent the
>>> states when commit trans is called, and every tree should match each other.
>>>
>>> Despite of this, after a transaction is committed, generation of the fs
>>> get increased and modified tree blocks will have the same generation number.
>>>
>>>> Blktrace shows that there
>>>> are 2       256KB writes, which are essentially writes to the data of
>>>> the root directory of the file system (which I found out through
>>>> btrfs-debug-tree).
>>>
>>>
>>> I'd say you didn't check btrfs-debug-tree output carefully enough.
>>> I strongly recommend to do vimdiff to get what tree is modified.
>>>
>>> At least the following trees are modified:
>>>
>>> 1) fs/subvolume tree
>>>      Rename modified the DIR_INDEX/DIR_ITEM/INODE_REF at least, and
>>>      updated inode time.
>>>      So fs/subvolume tree must be CoWed.
>>>
>>> 2) extent tree
>>>      CoW of above metadata operation will definitely cause extent
>>>      allocation and freeing, extent tree will also get updated.
>>>
>>> 3) root tree
>>>      Both extent tree and fs/subvolume tree modified, their root bytenr
>>>      needs to be updated and root tree must be updated.
>>>
>>> And finally superblocks.
>>>
>>> I just verified the behavior with empty btrfs created on a 1G file, only
>>> one file to do the rename.
>>>
>>> In that case (with 4K sectorsize and 16K nodesize), the total IO should be
>>> (3 * 16K) * 2 + 4K * 2 = 104K.
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
>>>
>>> For shell "sync" the difference is that, "sync" will write all dirty data
>>> pages to disk, and then commit transaction.
>>> While only calling btrfs_commit_transacation() doesn't trigger dirty page
>>> writeback.
>>>
>>> So there is a difference.
>>>
>>> And furthermore, if there is nothing to modified at all, sync will just
>>> skip the fs, so btrfs_commit_transaction() is not ensured if you call
>>> "sync".
>>>
>>>> Also, does it
>>>> imply that all the metadata held by the log tree is now checkpointed
>>>> to the respective trees?
>>>
>>>
>>> Log tree part is a little tricky, as the log tree is not really a journal
>>> for btrfs.
>>> Btrfs uses CoW for metadata so in theory (and in fact) btrfs doesn't need
>>> any journal.
>>>
>>> Log tree is mainly used for enhancing btrfs fsync performance.
>>> You can totally disable log tree by notreelog mount option and btrfs will
>>> behave just fine.
>>>
>>> And furthermore, I'm not very familiar with log tree, I need to verify the
>>> code to see if log tree is used in rename, so I can't say much right now.
>>>
>>> But to make things easy, I strongly recommend to ignore log tree for now.
>>>
>>>>
>>>> 2. Why are there 2 complete writes to the data held by the root
>>>> directory and not just 1? These writes are 256KB each, which is the
>>>> size of the extent allocated to the root directory
>>>
>>>
>>> Check my first calculation and verify the debug-tree output before and
>>> after rename.
>>>
>>> I think there is some extra factors affecting the number, from the tree
>>> height to your fs tree organization.
>>>
>>>>
>>>> 3. Why are the writes being done to the root directory of the file
>>>> system / subvolume and not just the parent directory where the unlink
>>>> happened?
>>>
>>>
>>> That's why I strongly recommend to understand btrfs on-disk format first.
>>> A lot of things can be answered after understanding the on-disk layout,
>>> without asking any other guys.
>>>
>>> The short answer is, btrfs puts all its child dir/inode info into one tree
>>> for one subvolume.
>>> (And the term "root directory" here is a little confusing, are you talking
>>> about the fs tree root or the root tree?)
>>>
>>> Not the common one tree for one inode layout.
>>>
>>> So if you rename one file in a subvolume, the subvolume tree get CoWed,
>>> which means from the leaf containing the key/item you want to modify, to the
>>> tree root will be CoWed.
>>>
>>> Thanks,
>>> Qu
>>>>
>>>>
>>>> It would be great if I could get the answers to these questions.
>>>>
>>>> Thanks,
>>>> Rohan
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
