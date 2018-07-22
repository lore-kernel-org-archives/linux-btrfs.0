Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 11.mo3.mail-out.ovh.net ([87.98.184.158]:47380 "EHLO
        11.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbeGVNBF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Jul 2018 09:01:05 -0400
Received: from player746.ha.ovh.net (unknown [10.109.160.12])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 97E411C85C3
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Jul 2018 08:07:32 +0200 (CEST)
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        hugo@carfax.org.uk
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
 <aa82a6ba-b961-25db-2487-59aa64193257@web.de>
 <79e88abd-d505-ec2b-a960-a07c0a5b7815@gmx.com>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <3af45179-e806-87ae-bcab-c9a82e4ec7f1@web.de>
Date: Sun, 22 Jul 2018 08:07:19 +0200
MIME-Version: 1.0
In-Reply-To: <79e88abd-d505-ec2b-a960-a07c0a5b7815@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


>>>>
>>>> I'm running my normal workstation with git kernels from
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
>>>>
>>>> and just got the second file system corruption in three weeks. I do not
>>>> have issues with stable kernels, and just want to give you a heads up
>>>> that there might be something seriously broken in current development
>>>> kernels.
>>>>
>>>> The first corruption was with a kernel based on 4.18.0-rc1
>>>> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
>>>> (wt-2018-07-09).
>>>> The first corruption definitely destroyed data, the second one has not
>>>> been looked at all, yet.
>>>>
>>>> After the reinstall I did run some scrubs, the last working one one week
>>>> ago.
>>>>
>>>> Of course this could be unrelated to the development kernels or even
>>>> btrfs, but two corruptions within weeks after years without problems is
>>>> very suspect.
>>>> And since btrfs also allowed to read corrupted data (with a stable
>>>> ubuntu kernel, see below for more details) it looks like this is indeed
>>>> an issue in btrfs, correct?
>>>
>>> Not in newer kernel anymore.
>>>
>>> Btrfs kernel module will do *restrict* check on tree blocks.
>>> So anything unexpected (or doesn't follow btrfs on-disk format) will be
>>> rejected by btrfs module.
>>>
>>> To avoid further corrupting the whole btrfs.
>>
>> Not sure I can follow that. Shouldn't I get a read error for a file due
>> to checksum mismatch if btrfs did not write it out itself?
> 
> It's not data corruption, but metadata (tree block) corruption.
> 
> So it could cause more serious problem.
> 
>> I could copy the complete git tree without any noticeable errors.
> 
> Because the corruption happens in extent tree, thus it doesn't affect fs
> tree (controlling how btrfs organize files/dirs/xattr) nor data.

I think we are now mixing the two btrfs problems I had.

#1 corrupted data. I reinstalled without doing anything else than
copying some files from it and a btrfs check --repair.

Quite many of the salvaged files from that FS (prior to running repair)
were just containing 0x1, from start to end of the file. While still
having a plausible size.

I did not notice any error logs for #1, the FS stayed RW till the very
end. The first indication that something was wrong was a missing mail in
Thunderbird. Other clients showed it, the affected system not. I
installed (gentoo, so compiled) updates, including systemd. On the next
power up the system was unbootable due to damaged system files.

I kept the btrfs repair log and uploaded it:
https://www.awhome.eu/index.php/s/6jXtBTEeyA2ns3d
Uncompressed that are 230MB.

#2 was the one we looked into here which seems to be meta data only. The
git tree I salvaged from #2 at least is still working and I have not
found any corruptions.

So I still think i should have got read errors for #1 if btrfs did not
itself write out the corrupted data somehow.

> 
>>>
>>>>
>>>> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSATA
>>>> 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is
>>>> enabled as mount option and there were roughly 5 other subvolumes.
>>>>
>>>> I'm currently backing up the full btrfs partition after the second
>>>> corruption which announced itself with the following log entries:
>>>>
>>>> [  979.223767] BTRFS critical (device sdc2): corrupt leaf: root=2
>>>> block=1029783552 slot=1, unexpected item end, have 16161 expect 16250
>>>
>>> This shows enough info of what's going wrong.
>>> Items overlaps or has holes in extent tree.
>>>
>>> Please dump the tree block by using the following command:
>>>
>>> # btrfs inspect dump-tree -b 1029783552 /dev/sdc2
>>
>> # btrfs inspect dump-tree -b 1029783552 /dev/sdc2
>> btrfs-progs v4.12
>> leaf 1029783552 items 204 free space 4334 generation 13058 owner 2
>> leaf 1029783552 flags 0x1(WRITTEN) backref revision 1
>> fs uuid 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
>> chunk uuid c55861e9-91f6-413f-85f6-5014d942c2bd
>>
>>         item 0 key (844283904 METADATA_ITEM 0) itemoff 16250 itemsize 33
>>                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
>>                 tree block skinny level 0
>>                 shared block backref parent 166690816
> 
>>         item 1 key (844300288 METADATA_ITEM 0) itemoff 16128 itemsize 33>                 extent refs 72620543991349248 gen 51228445761339392
> flags |FULL_BACKREF
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                               These are completely garbage.
>                               Looks pretty like due to some offset.
>>                 tree block skinny level 0
>>         item 2 key (844316672 METADATA_ITEM 0) itemoff 16128 itemsize 33
>>                 extent refs 72620543991349248 gen 51228445761339392 flags |FULL_BACKREF
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                               So is this slot.
>>                 tree block skinny level 0
> 
> While other slots looks good, it looks like a corruption in tree block
> creation.
> 
> And more strangely, btrfs has such item range/offset check each time we
> modify tree block.
> So if you didn't hit such problem, it mostly means your memory is corrupted.
> 
> And in this case, I don't think btrfs check can repair it.
> 
>>         item 3 key (844333056 METADATA_ITEM 0) itemoff 16151 itemsize 33
>>                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
>>                 tree block skinny level 0
>>                 shared block backref parent 166690816
>>         item 4 key (844349440 METADATA_ITEM 0) itemoff 16118 itemsize 33
>>                 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
>>                 tree block skinny level 0
>>                 shared block backref parent 166690816
>>         item 5 key (844365824 METADATA_ITEM 0) itemoff 16085 itemsize 33
> [snip]
>>> And please run "btrfs check" on the filesystem to show any other
>>> problems.
>>> (I assume there will be more problem than our expectation)
>>
>> Compared to the first crash this looks harmless:
> 
> Any error in btrfs check is harmful.
> Nothing reported as error is harmless.
> 
>> btrfs check --repair /dev/sdc2 2>&1 | tee repair
>> checking extents
>> incorrect offsets 16250 16161
>> corrupt extent record: key 844300288 169 16384
>> corrupt extent record: key 844316672 169 16384
>> ref mismatch on [844300288 16384] extent item 72620543991349248, found 1
>> Backref 844300288 parent 166690816 root 166690816 not found in extent tree
>> backpointer mismatch on [844300288 16384]
>> repair deleting extent record: key 844300288 169 0
>> adding new tree backref on start 844300288 len 16384 parent 166690816
>> root 166690816
>> Repaired extent references for 844300288
>> bad extent [844300288, 844316672), type mismatch with chunk
>> ref mismatch on [844316672 16384] extent item 72620543991349248, found 1
>> Backref 844316672 parent 528 root 528 not found in extent tree
>> backpointer mismatch on [844316672 16384]
>> repair deleting extent record: key 844316672 169 0
>> adding new tree backref on start 844316672 len 16384 parent 0 root 528
>> Repaired extent references for 844316672
>> bad extent [844316672, 844333056), type mismatch with chunk
>> Incorrect local backref count on 1325674496 root 534 owner 0 offset 0
>> found 0 wanted 1 back 0x557cc1a41cd0
>> Backref disk bytenr does not match extent record, bytenr=1325674496, ref
>> bytenr=208
>> Backref 1325674496 root 534 owner 979 offset 0 num_refs 0 not found in
>> extent tree
>> Incorrect local backref count on 1325674496 root 534 owner 979 offset 0
>> found 1 wanted 0 back 0x557cc3ca1530
>> backpointer mismatch on [1325674496 4096]
>> repair deleting extent record: key 1325674496 168 4096
>> adding new data backref on 1325674496 root 534 owner 979 offset 0 found 1
>> Repaired extent references for 1325674496
>> Fixed 0 roots.
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> enabling repair mode
>> Checking filesystem on /dev/sdc2
>> UUID: 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
>> Shifting item nr 1 by 89 bytes in block 4341760
>> Shifting item nr 2 by 56 bytes in block 4341760
>> cache and super generation don't match, space cache will be invalidated
>> found 381207048192 bytes used, no error found
>> total csum bytes: 85216324
>> total tree bytes: 1095172096
>> total fs tree bytes: 907313152
>> total extent tree bytes: 89915392
>> btree space waste bytes: 226140034
>> file data blocks allocated: 244093546496
>>  referenced 236476338176
>>
> 
> Fortunately, at least that 2 slots are the only corruptions.
> 
>>
>>>
>>>> [  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080:
>>>> errno=-5 IO failure
>>>> [  979.223810] BTRFS info (device sdc2): forced readonly
>>>> [  979.224599] BTRFS warning (device sdc2): Skipping commit of aborted
>>>> transaction.
>>>> [  979.224603] BTRFS: error (device sdc2) in cleanup_transaction:1847:
>>>> errno=-5 IO failure
>>>>
>>>> I'll restore the system from a backup - and stick to stable kernels for
>>>> now - after that, but if needed I can of course also restore the
>>>> partition backup to another disk for testing.
>>>
>>> Since it is your fs corrupted, using older kernel ignores such problem
>>> is not the long term solution in my opinion.
>>
>> I agree. I just want to verify it's indeed stable again.
>> It may well be some no kernel issue at all and just bad timing with some
>> HW breakdown.
> 
> At least for me, since btrfs verify we don't screw up tree blocks each
> time we update the tree block, it looks pretty like a unexpected memory
> corruption.
> 
> Memtest is recommend to locate such problem.
> 

RAM seems to be ok.
I have it running for >23h and it completed 5 full passes. Without any
error found...
It's still running pass 6 and I'll let it complete that one, too.

>>
>>>
>>>>
>>>> Here what I can say from the first crash:
>>>>
>>>> On Jul 4th I discovered severe file system corruptions and when booting
>>>> with init=/bin/bash even tools like parted failed with some report about
>>>> invalid ELF headers for some library. I started an Ubuntu 17.10 install
>>>> on another physical disk and copied some data from the damaged btrfs
>>>> volume to the Ubuntu disk. And while I COULD copy the files quite many
>>>> of the interesting ones were broken:
>>>> e.g. the git tree I rescued from the broken btrfs disk is unusable. The
>>>> broken files I found all look about the correct size but contain only
>>>> 0x01:
>>>> $ hexdump -C .git/objects/9d/732f6506e4cecd6d2b50c5008f9d1255198c1e
>>>> 00000000  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01
>>>> |................|
>>>> *
>>>> 00000e26
>>>>
>>>> After copying the files I tried a "btrfs check --repair" which was
>>>> finding countless errors and I aborted after I got more than 3 million
>>>> lines output.
>>>
>>> --repair should never be your first try by all means.
>>> And in fact, sometimes it could even further corrupt the fs.
>>
>> Ups, I just notice I have called it with --repair again. At least this
>> time I have a backup and can restore to the old state....
>>
>> I was aware of that the first time but lazy.
>> Problem was, that many basic system binaries were broken and it looked
>> like repairing it was more work than starting over from scratch.
>> I was already set on reinstalling and just kind of wanted to see what
>> happens.
> 
> That's fine, and in fact it fixes some thing, although still with
> something left.
> If you have ensured that memory is not the culprit, I could patch tree
> blocks manually to fix it.

With "started from scratch" I meant mkfs.btrfs. So there can't be
anything left from problem #1. This is a new filesystem...

Don't think it's worth the time fixing it, I did expect a crash again
and have snapshot exported on another disk which was not mounted.

So if there is nothing else we can find out here I'll just format the FS
again and restore the snapshot and see if I can get it corrupted again...

> 
> BTW, it looks like repair can only handles wrong tree block item
> removal, but fails to create a new correct one, thus still fails to fix it.
> 

Thanks for your support

Alexander
