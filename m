Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:58299 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdBMXFA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 18:05:00 -0500
Subject: Re: Root volume (ID 5) in deleting state
To: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nextsux@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
 <a103e413-d922-9c79-0075-1ce00a3cd7de@mendix.com>
 <af9179d8-cf9e-7eef-3150-477bf3a55ff8@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e6162766-c862-0098-858f-198e6f88e060@mendix.com>
Date: Tue, 14 Feb 2017 00:04:55 +0100
MIME-Version: 1.0
In-Reply-To: <af9179d8-cf9e-7eef-3150-477bf3a55ff8@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 02/13/2017 09:50 PM, Martin Mlynář wrote:
> On 13.2.2017 21:03, Hans van Kranenburg wrote:
>> On 02/13/2017 12:26 PM, Martin Mlynář wrote:
>>> I've currently run into strange problem with BTRFS. I'm using it as my
>>> daily driver as root FS. Nothing complicated, just few subvolumes and
>>> incremental backups using btrbk.
>>>
>>> Now I've noticed that my btrfs root volume (absolute top, ID 5) is in
>>> "deleting" state. As I've done some testing and googling it seems that
>>> this should not be possible.
>>>
>>> [...]
>>>
>>> # btrfs sub list -ad /mnt/btrfs_root/
>>> ID 5 gen 257505 top level 0 path <FS_TREE>/DELETED
>> I have heard rumours that this is actually a bug in the output of sub
>> list itself.
>>
>> What's the version of your btrfs-progs? (output of `btrfs version`)
> Sorry, I've lost this part:
> 
> $ btrfs version
> btrfs-progs v4.9
> 
>>
>>> # mount | grep btr
>>> /dev/mapper/vg0-btrfsroot on / type btrfs
>>> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=1339,subvol=/rootfs)
>>>
>>>
>>> /dev/mapper/vg0-btrfsroot on /mnt/btrfs_root type btrfs
>>> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=5,subvol=/)
>>>
>> The rumour was that it had something to do with using space_cache=v2,
>> which this example does not confirm.
> It looks you're right!
> 
> On a different machine:
> 
> # btrfs sub list / | grep -v lxc
> ID 327 gen 1959587 top level 5 path mnt/reaver
> ID 498 gen 593655 top level 5 path var/lib/machines
> 
> # btrfs sub list / -d | wc -l
> 0

Ok, apparently it's a regression in one of the latest versions then.
But, it seems quite harmless.

> # btrfs version
> btrfs-progs v4.8.2
> 
> # uname -a
> Linux nxserver 4.8.6-1-ARCH #1 SMP PREEMPT Mon Oct 31 18:51:30 CET 2016
> x86_64 GNU/Linux
> 
> # mount | grep btrfs
> /dev/vda1 on / type btrfs
> (rw,relatime,nodatasum,nodatacow,space_cache,subvolid=5,subvol=/)
> 
> Then I've upgraded this machine and:
> 
> # btrfs sub list / | grep -v lxc
> ID 327 gen 1959587 top level 5 path mnt/reaver
> ID 498 gen 593655 top level 5 path var/lib/machines
> 
> # btrfs sub list / -d | wc -l
> 1
> 
> # btrfs sub list / -d
> ID 5 gen 2186037 top level 0 path DELETED    <======
> 
> 1
> 
> # btrfs version
> btrfs-progs v4.9
> 
> # uname -a
> Linux nxserver 4.9.8-1-ARCH #1 SMP PREEMPT Mon Feb 6 12:59:40 CET 2017
> x86_64 GNU/Linux
> 
> # mount | grep btrfs
> /dev/vda1 on / type btrfs
> (rw,relatime,nodatasum,nodatacow,space_cache,subvolid=5,subvol=/)
> 
> 
>>
>>> # uname -a
>>> Linux interceptor 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET
>>> 2017 x86_64 GNU/Linux
>>>
>>> # btrfs fi show  /
>>> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>>>      Total devices 1 FS bytes used 132.89GiB
>>>      devid    1 size 200.00GiB used 200.00GiB path
>>> /dev/mapper/vg0-btrfsroot
>> As a side note, all of your disk space is allocated (200GiB of 200GiB).
>>
>> Even while there's still 70GiB of free space scattered around inside,
>> this might lead to out-of-space issues, depending on how badly
>> fragmented that free space is.
> I have not noticed this at all!
> 
> # btrfs fi show /
> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>     Total devices 1 FS bytes used 134.23GiB
>     devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot
> 
> # btrfs fi df /
> Data, single: total=195.96GiB, used=131.58GiB
> System, single: total=3.00MiB, used=48.00KiB
> Metadata, single: total=4.03GiB, used=2.64GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> After btrfs defrag there is no difference. btrfs fi show says still
> 200/200. I'll try to play with it.

Yes, this is the very first confusing thing every btrfs user encounters.

If you have a 200GiB disk, btrfs will start allocating raw disk space
from it in chunks of 256MiB (for metadata) and 1GiB (for data), when
needed. If, after some time, you throw away files or snapshots or for
whatever reason free up used space, you still have those big 1GiB sized
allocated blocks, which now have gaps of free space inside them.

In the above output, all of the 200GiB has been claimed for either data
or metadata use, in big chunks. In theory this should not be a problem,
unless you need to store more than 4.03GiB of metadata (no new space for
dedicated metadata chunks can be claimed any more).

The "used" in btrfs fi show output is the amount allocated ("claimed"),
which is the sum of the "total" numbers in btrfs fi df output.
The "used" in btrfs fi df is the actual amount of data stored in the
allocated space. Simple, huh...?

If you write new data, btrfs will either put it in free space inside the
already allocated space, or it will just not try hard enough, give up,
and try to claim more raw space (which is not there any more) and throw
up with ENOSPC errors. This leads to the usual "btrfs says my disk is
full, but df says I only have 60% used." reports you see on the mailing
list, because it's usually the first problem people run into when trying
btrfs. (and, no, your regular monitoring which looks at df output
doesn't work with btrfs)

So, as long as this is not better handled by default, it requires
babysitting (yes, really) to prevent that from happening. Luckily
there's something for that.  By abusing the 'btrfs balance' command,
which was originally meant to rebalance data equally over multiple
devices if you add more disks, we can also defragment free space.

So, to get the numbers of total raw disk space allocation down, you need
to defragment free space (compact the data), not defrag used space.

You can even create pictures of space utilization in your btrfs
filesystem, which might help understanding what it looks like right now: \o/

https://github.com/knorrie/btrfs-heatmap/

-- 
Hans van Kranenburg
