Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:43914 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdKKDN4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 22:13:56 -0500
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>, Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com>
 <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com>
Date: Sat, 11 Nov 2017 04:13:54 +0100
MIME-Version: 1.0
In-Reply-To: <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/11/2017 03:30 AM, Qu Wenruo wrote:
> 
> On 2017年11月11日 09:54, Hans van Kranenburg wrote:
>> On 11/11/2017 12:52 AM, Chris Murphy wrote:
>>> Hardware:
>>> HP Spectre which contains a SAMSUNG MZVLV256HCHP-000H1, which is an NVMe drive.
>>>
>>> Kernels:
>>> various but definitely 4.12.0 through 4.13.10
>>>
>>> Problem:
>>> Within seconds of the super being updated to point to a new root tree,
>>> the old root tree cannot be read with btrfs-debug-tree.
>>
>> Is this a problem, or is this just expected, by design?
> 
> It is a problem.
> 
> By design, tree block should only be discarded after no one is referring
> to it. Note: commit root (last committed transaction) also counts.
> 
> So that's to say, last committed transaction must be alive, until
> current transaction is committed.

Yes, well, that's no different than what I was saying.

> If tree block is discarded during a uncommitted transaction, and power
> loss happened, the fs can not be mounted any more (if a vital tree is
> corrupted).
> 
> Even after transaction commitment, discard a tree block of last
> transaction can lead to recovery problem (e.g. rollback the fs to
> previous trans using backup roots)
>>
>>> Example:
>>>
>>>
>>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>>> btrfs-progs v4.13.3
>>> node 84258750464 level 1 items 2 free 491 generation 200994 owner 1
>>> fs uuid 2662057f-e6c7-47fa-8af9-ad933a22f6ec
>>> chunk uuid 1df72dcf-f515-404a-894a-f7345f988793
>>>     key (EXTENT_TREE ROOT_ITEM 0) block 84258783232 (5142748) gen 200994
>>>     key (452 INODE_ITEM 0) block 84258881536 (5142754) gen 200994
>>>
>>> (wait 10-40 seconds while file system is in use)
>>
>> After the superblock is written, this space is freed up to be
>> overwritten by new writes immediately...
> 
> Nope, this should not be the case.

The example is a block from a "backup root". It's ok to be overwritten.

> The correct behavior is, new write should *never* overwrite tree blocks
> used by commit_root (last committed transaction).
> 
> Or there is nothing to protect btrfs from power loss.
> (Btrfs doesn't use journal, but completely rely metadata CoW to handle
> power loss)
> 
>>
>>> $ sudo btrfs-debug-tree -b 84258750464 /dev/nvme0n1p8
>>> btrfs-progs v4.13
>>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
>>> checksum verify failed on 84258750464 found E4E3BDB6 wanted 00000000
>>> bytenr mismatch, want=84258750464, have=0
>>> ERROR: failed to read 84258750464
>>> [chris@f26h ~]$
>>
>> Even when not using discard, there might be new data in that place now,
>> when the file system is in use...
> 
> As explained above, btrfs use CoW to survive power loss, especially for
> metadata, so tree blocks of last committed transaction should not be
> touched at all.
> 
> So, this is a problem, and I think that's why discard is not recommended
> for btrfs (yet).
> And we should have more runtime checks to ensure we won't allocate any
> space used by committed transaction.
> 
>>
>>> This suggests a problem for any kind of automatic recovery, should it
>>> be needed at next mount time, following a crash or power failure, as
>>> well as rendering the usebackuproot useless.
>>
>> Maybe the name backuproot is useless, because it's not a backup at all.
> 
> Most of the backup root is more or less useless, if and only if metadata
> CoW is done completely as design.

Is there an 'unless' missing here?

> One more chance to recover is never a bad idea.

It is a bad idea. The *only* case you can recover from is when you
freeze the filesystem *directly* after writing the superblock. Only in
that case you have both a consistent last committed and previous
transaction on disk.

If you do new writes and then again are able to mount with -o
usebackuproot and if any of the
transaction-before-the-last-committed-transaction blocks are overwritten
you're in a field of land mines and time bombs. Being able to mount
gives a false sense of recovery to the user in that case, because either
you're gonna crash into transid problems for metadata, or there are
files in the filesystem in which different data shows up than should,
potentially allowing users to see data from other users etc... It's just
dangerous.

> As you can see, if metadata CoW is completely implemented as designed,
> there will be no report of transid mismatch at all.
> And btrfs should be bullet proof from the very beginning, but none of
> these is true.

It is, it's not a bug. This is about the backup roots thingie, not about
the data from the last transaction.

> 
> Thanks,
> Qu
> 
>>
>> Only the most recent previous one is if you have to mount a filesystem
>> directly after some bug hosed your tree of trees during a final commit
>> when umounting just before?
>>
>>> I think until discard mount option has some kind of delay (generation
>>> based perhaps), so that at least the various backup trees, in
>>> particular the root tree, is not immediately subject to discard, that
>>> the Btrfs wiki needs to suggest the discard mount option is unsafe on
>>> SSD.
>>>
>>> While I have not experienced any other problems in roughly a year of
>>> using discard and Btrfs on this hardware, if I had needed a rollback
>>> offered by use of a backup tree, they simply wouldn't have been
>>> available, and I'd have been hosed.
>>> (Needs testing on LVM thinp to see if discard causes a similar problem
>>> with Btrfs on LVM thinly provisioned volumes, even with hard drives.)
>>
>> I actually start wondering why this option exists at all. I mean, even
>> when it seems you get a working filesystem back with it, there can be
>> metadata and data in all corners of the filesystem that already has been
>> overwritten?
>>
>> It was introduced in commit af31f5e5b "Btrfs: add a log of past tree
>> roots" and the only information we get is "just in case we somehow lose
>> the roots", which is an explanation for adding this feature that does
>> not really tell me much about it.
>>


-- 
Hans van Kranenburg
