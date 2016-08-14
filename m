Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34786 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbcHNQUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 12:20:41 -0400
Received: by mail-oi0-f53.google.com with SMTP id l203so37446503oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Aug 2016 09:20:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2336793.AMaAIAxWk4@discus>
References: <2336793.AMaAIAxWk4@discus>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 14 Aug 2016 10:20:39 -0600
Message-ID: <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com>
Subject: Re: Likelihood of read error, recover device failure raid10
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 13, 2016 at 9:39 AM, Wolfgang Mader
<Wolfgang_Mader@brain-frog.de> wrote:
> Hi,
>
> I have two questions
>
> 1) Layout of raid10 in btrfs
> btrfs pools all devices and than stripes and mirrors across this pool. Is it
> therefore correct, that a raid10 layout consisting of 4 devices a,b,c,d is
> _not_
>
>               raid0
>        |---------------|
> ------------      -------------
> |a|  |b|      |c|  |d|
>    raid1            raid1
>
> Rather, there is no clear distinction of device level between two devices
> which form a raid1 set which are than paired by raid0, but simply, each bit is
> mirrored across two different devices. Is this correct?

All of the profiles apply to block groups (chunks), and that includes
raid10. They only incidentally apply to devices since of course block
groups end up on those devices, but which stripe ends up on which
device is not consistent, and that ends up making Btrfs raid10 pretty
much only able to survive a single device loss.

I don't know if this is really thoroughly understood. I just did a
test and I kinda wonder if the reason for this inconsistent assignment
is a difference between the initial stripe>devid pairing at mkfs time,
compared to subsequent pairings done by kernel code. For example, I
get this from mkfs:

    item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15715 itemsize 176
        chunk length 16777216 owner 2 stripe_len 65536
        type SYSTEM|RAID10 num_stripes 4
            stripe 0 devid 4 offset 1048576
            dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
            stripe 1 devid 3 offset 1048576
            dev uuid: af95126a-e674-425c-af01-2599d66d9d06
            stripe 2 devid 2 offset 1048576
            dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
            stripe 3 devid 1 offset 20971520
            dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
    item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 37748736) itemoff 15539 itemsize 176
        chunk length 2147483648 owner 2 stripe_len 65536
        type METADATA|RAID10 num_stripes 4
            stripe 0 devid 4 offset 9437184
            dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
            stripe 1 devid 3 offset 9437184
            dev uuid: af95126a-e674-425c-af01-2599d66d9d06
            stripe 2 devid 2 offset 9437184
            dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
            stripe 3 devid 1 offset 29360128
            dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74
    item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 2185232384) itemoff 15363
itemsize 176
        chunk length 2147483648 owner 2 stripe_len 65536
        type DATA|RAID10 num_stripes 4
            stripe 0 devid 4 offset 1083179008
            dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
            stripe 1 devid 3 offset 1083179008
            dev uuid: af95126a-e674-425c-af01-2599d66d9d06
            stripe 2 devid 2 offset 1083179008
            dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
            stripe 3 devid 1 offset 1103101952
            dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74

Here you can see every chunk type has the same stripe to devid
pairing. But once the kernel starts to allocate more data chunks, the
pairing is different from mkfs, yet always (so far) consistent for
each additional kernel allocated chunk.


    item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 4332716032) itemoff 15187
itemsize 176
        chunk length 2147483648 owner 2 stripe_len 65536
        type DATA|RAID10 num_stripes 4
            stripe 0 devid 2 offset 2156920832
            dev uuid: 1c3038ca-2615-414e-9383-d326b942f647
            stripe 1 devid 3 offset 2156920832
            dev uuid: af95126a-e674-425c-af01-2599d66d9d06
            stripe 2 devid 4 offset 2156920832
            dev uuid: 736ba7b3-f21f-4643-8a59-9869b3526a82
            stripe 3 devid 1 offset 2176843776
            dev uuid: 969a95d3-d76d-44dc-9364-9d1f6e449a74

This volume now has about a dozen chunks created by kernel code, and
the stripe X to devid Y mapping is identical. Using dd and hexdump,
I'm finding that stripe 0 and 1 are mirrored pairs, they contain
identical information. And stripe 2 and 3 are mirrored pairs. And the
raid0 striping happens across 01 and 23 such that odd-numbered 64KiB
(default) stripe elements go on 01, and even-numbered stripe elements
go on 23. If the stripe to devid pairing were always consistent, I
could lose more than one device and still have a viable volume, just
like a conventional raid10. Of course you can't lose both of any
mirrored pair, but you could lose one of every mirrored pair. That's
why raid10 is considered scalable.

But apparently the pairing is different between mkfs and kernel code.
And due to that I can't reliably lose more than one device. There is
an edge case where I could lose two:



stripe 0 devid 4
stripe 1 devid 3
stripe 2 devid 2
stripe 3 devid 1

stripe 0 devid 2
stripe 1 devid 3
stripe 2 devid 4
stripe 3 devid 1


I could, in theory, lose devid 3 and devid 1 and still have one of
each stripe copies for all block groups, but kernel code doesn't
permit this:

[352467.557960] BTRFS warning (device dm-9): missing devices (2)
exceeds the limit (1), writeable mount is not allowed



> 2) Recover raid10 from a failed disk
> Raid10 inherits its redundancy from the raid1 scheme. If I build a raid10 from
> n devices, each bit is mirrored across two devices. Therefore, in order to
> restore a raid10 from a single failed device, I need to read the amount of
> data worth this device from the remaining n-1 devices.

Maybe? In a traditional raid10, rebuild of a faulty device means
reading 100% of its mirror device and that's it. For Btrfs the same
could be true, it just depends on where the block group copies are
located, they could all be on just one other device, or they could be
spread across more than one device. Also for Btrfs it's only copying
extents, it's not doing sector level rebuild, it'll skip the empty
space.

>In case, the amount of
> data on the failed disk is in the order of the number of bits for which I can
> expect an unrecoverable read error from a device, I will most likely not be
> able to recover from the disk failure. Is this conclusion correct, or am I am
> missing something here.

I think you're over estimating the probability of URE. They're pretty
rare, and it's far less likely if you're doing regular scrubs.

I haven't actually tested this but if a URE or even a checksum
mismatch were to happen on a data block group during rebuild following
replacing a failed device, I'd like to think Btrfs just complains, it
doesn't stop the remainder of the rebuild. If it happens on metadata
or system chunk, well that's bad and could be fatal.


As an aside, I'm finding the size information for the data chunk in
'fi us' confusing...

The sample file system contains one file:
[root@f24s ~]# ls -lh /mnt/0
total 1.4G
-rw-r--r--. 1 root root 1.4G Aug 13 19:24
Fedora-Workstation-Live-x86_64-25-20160810.n.0.iso


[root@f24s ~]# btrfs fi us /mnt/0
Overall:
    Device size:         400.00GiB
    Device allocated:           8.03GiB
    Device unallocated:         391.97GiB
    Device missing:             0.00B
    Used:               2.66GiB
    Free (estimated):         196.66GiB    (min: 196.66GiB)
    Data ratio:                  2.00
    Metadata ratio:              2.00
    Global reserve:          16.00MiB    (used: 0.00B)

## "Device size" is total volume or pool size, "Used" shows actual
usage accounting for the replication of raid1, and yet "Free" shows
1/2. This can't work long term as by the time I have 100GiB in the
volume, Used will report 200Gib while Free will report 100GiB for a
total of 300GiB which does not match the device size. So that's a bug
in my opinion.

Data,RAID10: Size:2.00GiB, Used:1.33GiB
   /dev/mapper/VG-1     512.00MiB
   /dev/mapper/VG-2     512.00MiB
   /dev/mapper/VG-3     512.00MiB
   /dev/mapper/VG-4     512.00MiB

## The file is 1.4GiB but the Used reported is 1.33GiB? That's weird.
And now in this area the user is somehow expected to know that all of
these values are 1/2 their actual value due to the RAID10. I don't
like this inconsistency for one. But it's made worse by using the
secret decoder ring method of usage when it comes to individual device
allocations. Very clearly Size if really 4, and each device has a 1GiB
chunk. So why not say that? This is consistent with the earlier
"Device allocated" value of 8GiB.


-- 
Chris Murphy
