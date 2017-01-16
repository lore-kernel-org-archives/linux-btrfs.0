Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50373 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750857AbdAPFsB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 00:48:01 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
 <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
 <1484499869.17186.1.camel@scientia.net>
 <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
 <1484535383.7577.53.camel@scientia.net>
 <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com>
 <1484542415.21166.1.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com>
Date: Mon, 16 Jan 2017 13:47:51 +0800
MIME-Version: 1.0
In-Reply-To: <1484542415.21166.1.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/16/2017 12:53 PM, Christoph Anton Mitterer wrote:
> On Mon, 2017-01-16 at 11:16 +0800, Qu Wenruo wrote:
>> It would be very nice if you could paste the output of
>> "btrfs-debug-tree -t extent <your_device>" and "btrfs-debug-tree -t
>> root
>> <your device>"
>>
>> That would help us to fix the bug in lowmem mode.
> I'll send you the link in a private mail ... if any other developer
> needs it, just ask me or Qu for the link.
>
>
>> BTW, if it's possible, would you please try to run btrfs-check
>> before
>> your next deletion on ro-snapshots?
> You mean in general, when I do my next runs of backups respectively
> snaphot-cleanup?
> Sure, actually I did this this time as well (in original mode, though),
> and no error was found.
>
> For what should I look out?

Nothing special, just in case the fs is already corrupted.

>
>
>> Not really needed, as all corruption happens on tree block of root
>> 6403,
>> it means, if it's a real corruption, it will only disturb you(make
>> fs
>> suddenly RO) when you try to modify something(leaves under that node)
>> in
>> that subvolume.
> Ah... and it couldn't cause corruption to the same data blocks if they
> were used by another snaphshot?

No, it won't cause corruption to any data block, no matter shared or not.

>
>
>
>> And I highly suspect if the subvolume 6403 is the RO snapshot you
>> just removed.
> I guess there is no way to find out whether it was that snapshot, is
> there?

"btrfs subvolume list" could do it."
If no output of 6403, then it's removed.

And "btrfs-debug-tree -t root" also has info for it.
A deleted subvolume won't have corresponding ROOT_BACKREF, and its 
ROOT_ITEM should have none-zero drop key.

And in your case, your subvolume is indeed undergoing deletion.


Also checked the extent tree, the result is a little interesting:
1) Most tree backref are good.
    In fact, 3 of all the 4 errors reported are tree blocks shared by
    other subvolumes, like:

item 77 key (51200000 METADATA_ITEM 1) itemoff 13070 itemsize 42
		extent refs 2 gen 11 flags TREE_BLOCK|FULL_BACKREF
		tree block skinny level 1
		tree block backref root 7285
		tree block backref root 6572

This means the tree blocks are share by 2 other subvolumes,
7285 and 6572.

7285 subvolume is completely OK, while 6572 is also undergoing subvolume 
deletion(while real deletion doesn't start yet).

And considering the generation, I assume 6403 is deleted before 6572.

So we're almost clear that, btrfs (maybe only btrfsck) doesn't handle it 
well if there are multiple subvolume undergoing deletion.

This gives us enough info to try to build such image by ourselves now.
(Although still quite hard to do though).

Also that also explained why btrfs-progs test image 021 won't trigger 
the problem.
As it's only one subvolume undergoing deletion and no full backref extent.



And for the scary lowmem mode, it's false alert.

I manually checked the used size of a block group and it's OK.

BTW, most of your block groups are completely used, without any space.
But interestingly, mostly data extent size are just 512K, larger than
compressed extent upper limit, but still quite small.

In other words, your fs seems to be fragmented considering the upper 
limit of a data extent is 128M.
(Or your case is quite common in common world?)

>
>
>
>> If 'btrfs subvolume list' can't find that subvolume, then I think
>> it's
>> mostly OK for you to RW mount and wait the subvolume to be fully
>> deleted.
>>
>> And I think you have already provided enough data for us to, at
>> least
>> try to, reproduce the bug.
>
> I won't do the remount,rw this night, so you have the rest of your
> day/night time to think of anything further I should test or provide
> you with from that fs... then it will be "gone" (in the sense of
> mounted RW).
> Just give your veto if I should wait :)

At least from extent and root tree dump, I found nothing wrong.

It's still possible that some full backref needs to be checked from 
subvolume tree (consdiering your fs size, not really practical) and can 
be wrong, but the possibility is quite low.
And in that case, there should be more than 4 extent tree errors reported.

So you are mostly OK to mount it rw any time you want, and I have 
already downloaded the raw data.

Hard part is remaining for us developers to build such small image to 
reproduce your situation then.

Thanks,
Qu
>
>
> Thanks,
> Chris.
>


