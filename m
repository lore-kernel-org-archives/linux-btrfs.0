Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbcBZBV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 20:21:56 -0500
Subject: Re: how many chunk trees and extent trees present
To: sri <toyours_sridhar@yahoo.co.in>, <linux-btrfs@vger.kernel.org>
References: <loom.20150417T081705-332@post.gmane.org>
 <20150417091911.GK22084@carfax.org.uk>
 <loom.20150417T115204-272@post.gmane.org>
 <loom.20160225T125826-47@post.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CFA8A7.5080501@cn.fujitsu.com>
Date: Fri, 26 Feb 2016 09:21:43 +0800
MIME-Version: 1.0
In-Reply-To: <loom.20160225T125826-47@post.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



sri wrote on 2016/02/25 12:16 +0000:
> Do you mean allocated to any file in the subvolume, or do you mean
>>> *exclusively* allocated to that subvolume and not shared with any
>>> other?
>
> Hi,
> Like ext3/ext4, I can find all used blocks of the file system. Once
> identified, I can just copy those blocks for backup.

In btrfs, it's also very easy to find, just iterate all items in extent 
tree.
All metadata/data blocks have its METADATA_ITEM/EXTENT_ITEM in extent tree.
Your only concern to copy all these data should be btrfs chunk mapping.

Btrfs already has a tool to do such backup for metadata. Btrfs-image.
Although it's mainly used for debug, so it doesn't backup data though.

> The bit map
> provided by ext3/ext4 includes blocks allocated for both metadata and
> data, backup/recovery won't consume much space.
>
> For btrfs, multiple subvolumes can be created on pool of disks and each
> subvolume can consider as individual file system, I want to know a
> mechanism of identifying blocks allocated for the the subvolume through
> its snapshot so that for recovery, i can able to recovery those blocks
> only.

Unfortunately, all btrfs subvolumes/snapshots shares the same extent tree.
And that's why btrfs subvolume is called *sub* volume, not volume.
One subvolume can't function completely independently.

Although you can mount them as individual filesystem, it's still not 
full filesystem.


BTW, about separate extent/chunk tree, just as Hugo mentioned, it's 
planned to just reduce lock concurrency.
IMHO, it would be per-chunk extent/chunk tree design.

For me, it's almost impossible to do per-subvolume extent/chunk tree.
Things like incoming btrfs in-band de-duplication and existing 
btrfs_clone/reflink can easily refer data outside a subvolume.
Such design will just reduce the advantage of btrfs.

>
> If btrfs is created on 10 disks each of 100gb and one subvolume is 10GB,
> backup window will be less for just backing up the subvolume.
>
> I checked btrfs send/receive but the problem with send/receive is
> 1. It is file level dump

Isn't it done at subvolume/snapshot level?

> 2. previous snapshot should be present to get incremental otherwise it
> generates full backup again.

IMHO that's what incremental means.
The point is, btrfs snapshot can, and in most case, share metadata btree 
with its source subvolume/snapshot.
This design makes btrfs snapshot small and fast(16K for one snapshot, 
and creation is very fast).
But that's require strict incremental send, so we need its source 
snapshot in the filesystem.



At least for me, I still don't quite get the point of your goal.

If you want to incremental backup, then either use send of btrfs, or use 
more generic rsync method.


For understanding btrfs extent layout (including chunk and extent tree), 
I'd recommend to use btrfs-debug-tree and refer to btrfs wiki 
(https://btrfs.wiki.kernel.org/index.php/Btree_Items) as a start point.

Thanks,
Qu

>
>
> sri <toyours_sridhar <at> yahoo.co.in> writes:
>
>>
>> Hugo Mills <hugo <at> carfax.org.uk> writes:
>>
>>>
>>> On Fri, Apr 17, 2015 at 06:24:05AM +0000, sri wrote:
>>>> Hi,
>>>> I have below queries. Could somebody help me in understanding.
>>>>
>>>> 1)
>>>> As per my understanding btrfs file system uses one chunk tree and
>> one
>>>> extent tree for entire btrfs disk allocation.
>>>>
>>>> Is this correct?
>>>
>>>     Yes.
>>>
>>>> In, some article i read that future there will be more chunk tree/
>> extent
>>>> tree for single btrfs. Is this true.
>>>
>>>     I recall, many moons ago, Chris saying that there probably
> wouldn't
>>> be.
>>>
>>>> If yes, I would like to know why more than one chunk / extent tree
>> is
>>>> required to represent one btrfs file system.
>>>
>>>     I think the original idea was that it would reduce lock
> contention
>>> on the tree root.
>>>
>>>> 2)
>>>>
>>>> Also I would like to know for a subvolume / snapshot , is there a
>>>> provision to ask btrfs , represent all blocks belongs to that
>>>> subvolume/snapshot should handle with a separate chunk tree and
>> extent
>>>> tree?
>>>
>>>     No.
>>>
>>>> I am looking for a way to traverse a subvolume preferably a
> snapshot
>> and
>>>> identify all disk blocks (extents) allocated for that particular
>> subvolume
>>>> / snapshot.
>>>
>>>     Do you mean allocated to any file in the subvolume, or do you
> mean
>>> *exclusively* allocated to that subvolume and not shared with any
>>> other?
>>>
>>>     The former is easy -- just walk the file tree, and read the
> extents
>>> for each file. The latter is harder, because you have to look for
>>> extents that are not shared, and extents that are only shared within
>>> the current subvolume (think reflink copies within a subvol). I
> think
>>> you can do that by counting backrefs, but there may be big race
>>> conditions involved on a filesystem that's being written to (because
>>> the backrefs aren't created immediately, but delayed for performance
>>> reasons).
>>>
>>>     Note that if all you want is the count of those blocks (rather
> than
>>> the block numbers themselves), then it's already been done with
>>> qgroups, and you don't need to write any btrfs code at all.
>>>
>>>     What exactly are you going to be doing with this information?
>>>
>>>     Hugo.
>>>
>>
>> I am trying a way to get all files and folders of a snapshot volume
>> without making file system level calls (fopen etc..)
>>
>> I want to write code to understand the corresponding snapshot btree
> and
>> used related chunk tree and extent tree, and find out for each file
>> (inode) all extent blocks.
>> If I want to backup, I will use above method to traverse snapshot
>> subvolume at disk level and copy all blocks of files/directories.
>>
>> Thank you
>> sri
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> in
>> the body of a message to majordomo <at> vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


