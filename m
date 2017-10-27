Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:40022 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdJ0Vkj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 17:40:39 -0400
Subject: Re: Data and metadata extent allocators [1/2]: Recap: The data story
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
 <1833040.vtX8kJ14V9@merkaba>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d4886831-8dee-b736-5ee7-e71e5c6d1c3c@mendix.com>
Date: Fri, 27 Oct 2017 23:40:38 +0200
MIME-Version: 1.0
In-Reply-To: <1833040.vtX8kJ14V9@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 10/27/2017 10:10 PM, Martin Steigerwald wrote:
>> Q: How do I fight this and prevent getting into a situation where all
>> raw space is allocated, risking a filesystem crash?
>> A: Use btrfs balance to fight the symptoms. It reads data and writes it
>> out again without the free space fragments.
> 
> What do you mean by a filesystem crash? Since kernel 4.5 or 4.6 I don´t see any 
> BTRFS related filesystem hangs anymore on the /home BTRFS Dual SSD RAID 1 on my 
> Laptop, which one or two copies of Akonadi, Baloo and other desktop related 
> stuff write *heavily to* and which has all free space allocated into cunks 
> since a pretty long time:
> 
> merkaba:~> btrfs fi usage -T /home
> Overall:
>     Device size:                 340.00GiB
>     Device allocated:            340.00GiB
>     Device unallocated:            2.00MiB
>     Device missing:                  0.00B
>     Used:                        290.32GiB
>     Free (estimated):             23.09GiB      (min: 23.09GiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
>                           Data      Metadata System              
> Id Path                   RAID1     RAID1    RAID1    Unallocated
> -- ---------------------- --------- -------- -------- -----------
>  1 /dev/mapper/msata-home 163.94GiB  6.03GiB 32.00MiB     1.00MiB
>  2 /dev/mapper/sata-home  163.94GiB  6.03GiB 32.00MiB     1.00MiB
> -- ---------------------- --------- -------- -------- -----------
>    Total                  163.94GiB  6.03GiB 32.00MiB     2.00MiB
>    Used                   140.85GiB  4.31GiB 48.00KiB
> 
> I didn´t do a balance on this filesystem since a long time (kernel 4.6).

Yep, but it simply means your filesystem does not need to allocate a new
chunk for either data or metadata, since it has enough room inside to
reuse when you're doing your things.

On a filesystem that sees a large amount of writes and deletes of files,
say, adding 340GiB every day, and expiring 340GiB of data every day,
adding, removing and rewriting tens of GiBs of metadata every day,
taking such a risk is a total no go.

If you run out of that 1.7GiB - 512.00MiB = ~1.2GiB of metadata that is
free now, the filesystem stops working. Also, you cannot solve it
anymore at that point (probably also not at this point) by making raw
space unallocated with balance, because every balance action will fail
because it also hits the out of space condition.

> Granted my filesystem is smaller than the typical backup BTRFS. I do have two 3 
> TB and one 1,5 TB SATA disks I backup to and another 2 TB BTRFS on a backup 
> server that I use for borgbackup (and that doesn´t yet do any snapshots and 
> may be better of running as XFS as it doesn´t really need snapshots as 
> borgbackup takes care of that. A BTRFS snapshot would only come handy to be 
> able to go back to a previous borgbackup repo in case it for whatever reason 
> gets corrupted or damaged / deleted by an attacker who only access to non 
> privileged user). – However all of these filesystems have plenty of free space 
> currently and are not accessed daily.
> 
>> Q: Why would it crash the file system when all raw space is allocated?
>> Won't it start trying harder to reuse the free space inside?
>> A: Yes, it will, for data. The big problem here is that allocation of a
>> new metadata chunk when needed is not possible any more.
> 
> And there it hangs or really crashes?

It will probably throw itself in read-only mode and stop doing anything
else from that point.

> […]
> 
>> Q: Why do the pictures of my data block groups look like someone fired a
>> shotgun at it. [3], [4]?
>> A: Because the data extent allocator that is active when using the 'ssd'
>> mount option both tends to ignore smaller free space fragments all the
>> time, and also behaves in a way that causes more of them to appear. [5]
>>
>> Q: Wait, why is there "ssd" in my mount options? Why does btrfs think my
>> iSCSI attached lun is an SSD?
>> A: Because it makes wrong assumptions based on the rotational attribute,
>> which we can also see in sysfs.
>>
>> Q: Why does this ssd mode ignore free space?
>> A: Because it makes assumptions about the mapping of the addresses of
>> the block device we see in linux and the storage in actual flash chips
>> inside the ssd. Based on that information it decides where to write or
>> where not to write any more.
>>
>> Q: Does this make sense in 2017?
>> A: No. The interesting relevant optimization when writing to an ssd
>> would be to write all data together that will be deleted or overwritten
>> together at the same time in the future. Since btrfs does not come with
>> a time machine included, it can't do this. So, remove this behaviour
>> instead. [6]
>>
>> Q: What will happen when I use kernel 4.14 with the previously mentioned
>> change, or if I change to the nossd mount option explicitely already?
>> A: Relatively small free space fragments in existing chunks will
>> actually be reused for new writes that fit, working from the beginning
>> of the virtual address space upwards. It's like tetris, trying to
>> completely fill up the lowest lines first. See the big difference in
>> behavior when changing extent allocator happening at 16 seconds into
>> this timelapse movie: [7] (virtual address space)
> 
> I see a difference in behavior but I do not yet fully understand what I am 
> looking at.

It's hilbert sorted:
https://github.com/knorrie/btrfs-heatmap/blob/develop/doc/curves.md

In the lower left corner, you suddenly see all space becoming bright
white instead, which means it's trying to fill up all chunks too 100%
usage from then on.

>> Q: But what if all my chunks have badly fragmented free space right now?
>> A: If your situation allows for it, the simplest way is running a full
>> balance of the data, as some sort of big reset button. If you only want
>> to clean up chunks with excessive free space fragmentation, then you can
>> use the helper I used to identify them, which is
>> show_free_space_fragmentation.py in [8]. Just feed the chunks to balance
>> starting with the one with the highest score. The script requires the
>> free space tree to be used, which is a good idea anyway.
> 
> Okay, when I understand this correctly I don´t need to use "nossd" with kernel 
> 4.14, but it would be good to do a full "btrfs filesystem balance" run on all 
> the SSD BTRFS filesystems or all other ones with rotational=0.

Well, every use case is different. If you only store files that are a
few hundreds of MB big, you'll never see a problem with the old ssd mode.

If you have a badly treated filesystem that has seen many small writes
and deletes (e.g. the example post I linked with the videos what happens
when you put mailman storage or /var/log on it), then you might have so
many small free space extents all over the place that it's a good idea
to clean them up first, instead of having your new writes also not fit
into them now it's allowed with nossd / tetris allocator.

> What would be the benefit of that? Would the filesystem run faster again? My 
> subjective impression is that performance got worse over time. *However* all 
> my previous full balance attempts made the performance even more worse. So… is 
> a full balance safe to the filesystem performance meanwhile?

I can't say anything about that. One of the other things I learned is
that there's a fair share of "butterfly effect" going on in a
filesystem, where everything that happens or has happened in the past
influences anything, and anything could happen if you try something.

> I still have the issue that fstrim on /home only works with patch from Lutz 
> Euler from 2014, which is still not in mainline BTRFS. Maybe it would be a 
> good idea to recreate /home in order to get rid of that special "anomaly" of 
> the BTRFS that fstrim don´t work without this patch.

I don't know about that patch, what does it do?

> Maybe a least a part of this should go into BTRFS kernel wiki as it would be 
> more easy to find there for users.
> 
> I wonder about a "upgrade notes for users" / "BTRFS maintenance" page that 
> gives recommendations in case some step is recommended after a major kernel 
> update and general recommendations for maintenance. Ideally most of this would 
> be integrated into BTRFS or a userspace daemon for it and be handled 
> transparently and automatically. Yet a full balance is an expensive operation 
> time-wise and probably should not be started without user consent.

Deciding on what's needed totally depends on what state the filesystem
is in. The inspection and visualization tools help with that.

And, in 2017, btrfs is still not a filesystem to just choose in a linux
installer and then forget about it without getting in trouble ever.
IMHO.

At least one of the awesome things of btrfs is that it provides such a
rich API and metadata search to build those tools to see what's going on
inside. :D

> I do wonder about the ton of tools here and there and I would love some btrfsd 
> or… maybe even more generic fsd filesystem maintenance daemon which would do 
> regular scrubs and whatever else makes sense. It could use some configuration 
> in the root directory of a filesystem and work for BTRFS and other filesystem 
> that do have beneficial online / background upgraded like XFS which also has 
> online scrubbing by now (at least for metadata).

Have fun,
Hans
