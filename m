Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33134 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdCCBtL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 20:49:11 -0500
Received: by mail-yw0-f171.google.com with SMTP id s15so48644587ywg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Mar 2017 17:48:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bcb4b84b-2ae1-cf02-33e5-6ca17ae18840@cn.fujitsu.com>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net> <22712.48434.400550.346157@tree.ty.sabi.co.uk>
 <CAJCQCtSwBZKiZWA83dv_bvra1548eRtHJy7Gbqsbs_Hy56aSGw@mail.gmail.com> <bcb4b84b-2ae1-cf02-33e5-6ca17ae18840@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 2 Mar 2017 18:48:03 -0700
Message-ID: <CAJCQCtRJaNNFtE4Y7RAsgoD55F78HG_gyMxfkjVusrdYXFVDLw@mail.gmail.com>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 2, 2017 at 6:18 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 03/03/2017 09:15 AM, Chris Murphy wrote:
>>
>> [1805985.267438] BTRFS info (device dm-6): allowing degraded mounts
>> [1805985.267566] BTRFS info (device dm-6): disk space caching is enabled
>> [1805985.267676] BTRFS info (device dm-6): has skinny extents
>> [1805987.187857] BTRFS warning (device dm-6): missing devices (1)
>> exceeds the limit (0), writeable mount is not allowed
>> [1805987.228990] BTRFS error (device dm-6): open_ctree failed
>> [chris@f25s ~]$ sudo mount -o noatime,degraded,ro /dev/mapper/sdb /mnt
>> [chris@f25s ~]$ sudo btrfs fi df /mnt
>> Data, RAID1: total=434.00GiB, used=432.46GiB
>> Data, single: total=1.00GiB, used=1.66MiB
>> System, RAID1: total=8.00MiB, used=48.00KiB
>> System, single: total=32.00MiB, used=32.00KiB
>> Metadata, RAID1: total=2.00GiB, used=729.17MiB
>> Metadata, single: total=1.00GiB, used=0.00B
>> GlobalReserve, single: total=495.02MiB, used=0.00B
>> [chris@f25s ~]$
>>
>>
>>
>> So the sequence is:
>> 1. mkfs.btrfs -d raid1 -m raid1 <devs 2x)
>> 2. fill it with a bunch of data over a few months, always mounted
>> normally with default options
>> 3. physically remove 1 of 2 devices, and do a degraded mount. This
>> mounts without error, and more stuff is added. Volume is umounted.
>> 4. Try to mount the same 1 of 2 devices, with degraded mount option,
>> and I get the first error, "writeable mount is not allowed".
>> 5. Try to mount the same 1 of 2 devices, with degraded,ro option, and
>> it mounts, and then I captured the 'btfs fi df' above.
>>
>> So very clearly there are single chunks added during the degraded rw
>> mount.
>>
>> But does 1.66MiB of data in that single data chunk make sense? And
>> does 0.00 MiB of metadata in that single metadata chunk make sense?
>> I'm not sure, seems unlikely. Most of what happened in that subvolume
>> since the previous snapshot was moving things around, reorganizing,
>> not adding files. So, maybe 1.66MiB data added is possible? But
>> definitely the metadata changes must be in the raid1 chunks, while the
>> newly created single profile metadata chunk is left unused.
>>
>> So I think there's more than one bug going on here, separate problems
>> for data and metadata.
>
>
> IIRC I submitted a patch long time ago to check each chunk to see if it's OK
> to mount in degraded mode.
>
> And in your case, it will allow RW degraded mount since the stripe of that
> single chunk is not missing.
>
> That patch is later merged into hot-spare patchset, but AFAIK it will be a
> long long time before such hot-spare get merged.
>
> So I'll update that patch and hope it can solve the problem.
>

OK thanks. Yeah I should have said that this is not a critical
situation for me. It's just a confusing situation.

In particular that people could do a btrfs replace; or do btrfs dev
add, then btrfs dev missing, and what happens? There's some data
that's not replicated on the replacement drive because it's single
profile, and if that happens to be metadata it's possibly
unpredictable what happens when the drive with single chunks dies. At
the very least there is going to be some data loss. It's entirely
possible the drive that's missing these single chunks can't be mounted
degraded. And for sure it's possible that it can't be used for
replication, when doing a device replace for the 1st device with the
only copy of these single chunks.

Again, my data is fine. The problem I'm having is this:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.10.1

Which says in the first line, in part, "focusing on fault tolerance,
repair and easy administration" and quite frankly this sort of
enduring bug in this file system that's nearly 10 years old now, is
rendered misleading, and possibly dishonest. How do we describe this
file system as focusing on fault tolerance when, in the identical
scenario using mdadm or LVM raid, the user's data is not mishandled
like it is on Btrfs with multiple devices?



-- 
Chris Murphy
