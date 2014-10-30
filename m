Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:56948 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaJ3DRh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 23:17:37 -0400
Received: by mail-qc0-f173.google.com with SMTP id x3so3548125qcv.18
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 20:17:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54517726.5070507@tevsa.net>
References: <544FC921.2090900@tevsa.net>
	<CAPL5yKfQ1s4w9LbXwxGrJ-coSy8G1p=hpkkwhPT8oU8cqWS1eg@mail.gmail.com>
	<54517726.5070507@tevsa.net>
Date: Wed, 29 Oct 2014 23:17:36 -0400
Message-ID: <CAPL5yKcYT7Nv0u3=6arGwxVk46HG4mSGf0b1po-euUGcWQJGEA@mail.gmail.com>
Subject: Re: Btrfs raid1 array has issues with rtorrent usage pattern.
From: Dan Merillat <dan.merillat@gmail.com>
To: Alec Blayne <ab@tevsa.net>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's specifically BTRFS related, I was able to reproduce it on a bare
drive (no lvm, no md, no bcache).  It's not bad RAM, I was able to
reproduce it on multiple machines running either 3.17 or late RCs.

I've tested 3.18-rc2 for about 2 hours now, can't get any failures, so
that's good.  If anyone else can reproduce this it'll probably need to
be sent to 3.17-stable.

On Wed, Oct 29, 2014 at 7:24 PM, Alec Blayne <ab@tevsa.net> wrote:
> Really nice to know it's already getting handled :)
>
> I'm already "downgrading" to 3.16.6 now that I know I won't have that
> issue. I was already planning to because of the read-only snapshots issue.
>
> Thank you and good luck debugging!
>
> On 29-10-2014 21:50, Dan Merillat wrote:
>> I'm in the middle of debugging the exact same thing.  3.17.0 -
>> rtorrent dies with SIGBUS.
>>
>> I've done some debugging, the sequence is something like this:
>> open a new file
>> fallocate() to the final size
>> mmap() all (or a portion) of the file
>> write to the region
>> run SHA1 on that mmap'd region to validate the chink
>> crash, eventually.  Generally not at the same point.
>>
>> Reading that file (cat > /dev/null) returns -EIO.
>>
>> Looking up the process maps, the SIGBUS appears to be happening in the
>> middle of a mapped region of a pre-allocated file - I.E. it shouldn't
>> be.  I'm not completely ruling out a rtorrent bug but it appears sane
>> to me.
>>
>> Weirder: "old" files, that have been around a while, work just fine for seeding.
>> I've re-hashed my entire collection without an error.
>>
>> Seeing this on both inherit-COW and no-inherit-COW files, and the
>> filesystem is not using compression.
>>
>> The interesting part is going back and attempting to read the files
>> later they sometimes don't throw an IO error.
>>
>> Absolutely nothing in dmesg.
>>
>> Working on a testcase that triggers it reliably but no luck so far.  I
>> thought I had bad RAM but two people upgrading to 3.17 and seeing the
>> same bug at around the same time can't be a coincidence.  I rebooted
>> to 3.17 on the 25th, the first new download was on the 28th and that
>> failed.
>>
>> Working on a testcase for it that's more reproducable than "go grab
>> torrent files with rtorrent".
>>
>> On Tue, Oct 28, 2014 at 12:49 PM, Alec Blayne <ab@tevsa.net> wrote:
>>> Hi, it seems that when using rtorrent to download into a btrfs system,
>>> it leads to the creation of files that fail to read properly.
>>> For instance, I get rtorrent to crash, but if I try to rsync the file he
>>> was writting into someplace else, rsync also fails with the message
>>> "can't map file "$file": Input/Output error (5)".
>>> If I give it time, eventually the file gets into a good state and I can
>>> rsync it somewhere else (as long as rtorrent doesn't keep writting into
>>> it). This doesn't happen using ext4 on the same system.
>>>
>>> No btrfs errors, or any other errors, show up in any log. Scrubbing or
>>> balancing don't turn up any issues. I've tried using a subvolume mounted
>>> with nodatacow and/or flushoncommit, which didn't help. I'm not using
>>> quotas and at some point had a single snapshot that I deleted. The
>>> filesystem was originally created recently (on a 3.16.4+ kernel).
>>>
>>> Here's what the array looks like:
>>>
>>> Label: 'data'  uuid: ffe83a3d-f4ba-46b7-8424-4ec3380cb811
>>>         Total devices 4 FS bytes used 3.14TiB
>>>         devid    4 size 2.73TiB used 2.36TiB path /dev/sdd1
>>>         devid    5 size 1.82TiB used 1.45TiB path /dev/sdc1
>>>         devid    6 size 1.82TiB used 1.45TiB path /dev/sdb1
>>>         devid    7 size 1.82TiB used 1.45TiB path /dev/sda1
>>>
>>> Btrfs v3.17
>>>
>>> Data, RAID1: total=3.34TiB, used=3.13TiB
>>> System, RAID1: total=32.00MiB, used=512.00KiB
>>> Metadata, RAID1: total=10.00GiB, used=7.31GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>>
>>> On linux 3.17.1: Linux 3.17.1-gentoo-r1 #3 SMP PREEMPT Tue Oct 28
>>> 02:43:11 WET 2014 x86_64 AMD Athlon(tm) 5350 APU with Radeon(tm) R3
>>> AuthenticAMD GNU/Linux
>>>
>>> I'm utterly puzzled and clueless at how to dig into this issue.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
