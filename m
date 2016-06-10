Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34435 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbcFJUUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 16:20:43 -0400
Received: by mail-vk0-f54.google.com with SMTP id e4so112124196vkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 13:20:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5736DFA3.3090904@aarghimedes.fi>
References: <5736DFA3.3090904@aarghimedes.fi>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 10 Jun 2016 22:20:40 +0200
Message-ID: <CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
Subject: Re: Kernel crash on mount after SMR disk trouble
To: Jukka Larja <roskakori@aarghimedes.fi>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 14, 2016 at 10:19 AM, Jukka Larja <roskakori@aarghimedes.fi> wrote:
> In short:
>
> I added two 8TB Seagate Archive SMR disk to btrfs pool and tried to delete
> one of the old disks. After some errors I ended up with file system that can
> be mounted read-only, but crashes the kernel if mounted normally. Tried
> btrfs check --repair (which noted that space cache needs to be zeroed) and
> zeroing space cache (via mount parameter), but that didn't change anything.
>
> Longer version:
>
> I was originally running Debian Jessie with some pretty recent kernel (maybe
> 4.4), but somewhat older btrfs tools. After the trouble started, I tried

You should at least have kernel 4.4, the critical patch for supporting
this drive was added in 4.4-rc3 or 4.4-rc4, i dont remember exactly.
Only if you somehow disable NCQ completely in your linux system
(kernel and more) or use a HW chipset/bridge that does that for you it
might work.

> updating (now running Kernel 4.5.1 and tools 4.4.1). I checked the new disks
> with badblocks (no problems found), but based on some googling, Seagate's
> SMR disks seem to have various problems, so the root cause is probably one
> type or another of disk errors.

Seagate provides a special variant of the linux ext4 fs system that
should then play well with their SMR drive. Also the advice is to not
use this drive in a array setup; the risk is way to high that they
can't keep up with the demands of the higher layers and then get
resets or their FW crashes. You should have had also have a look at
your system's and drive timeouts (see scterc). To summarize: adding
those drives to an btrfs raid array is asking for trouble.

I am using 1 such drive with an Intel J1900 SoC (Atom, SATA2) and it
works, although I get still the typical error occasionally. As it is
just a btrfs receive target, just 1 fs dup/dup/single for the whole
drive, all CoW, it survives those lockups or crashes, I just restart
the board+drive. In general, reading back multi-TB ro snapshots works
fine and is on par with Gbps LAN speeds.

> Here's the output of btrfs fi show:
>
> Label: none  uuid: 8b65962d-0982-449b-ac6f-1acc8397ceb9
>         Total devices 12 FS bytes used 13.15TiB
>         devid    1 size 3.64TiB used 3.36TiB path /dev/sde1
>         devid    2 size 3.64TiB used 3.36TiB path /dev/sdg1
>         devid    3 size 3.64TiB used 3.36TiB path /dev/sdh1
>         devid    4 size 3.64TiB used 3.34TiB path /dev/sdf1
>         devid    5 size 1.82TiB used 1.44TiB path /dev/sdi1
>         devid    6 size 1.82TiB used 1.54TiB path /dev/sdl1
>         devid    7 size 1.82TiB used 1.51TiB path /dev/sdk1
>         devid    8 size 1.82TiB used 1.54TiB path /dev/sdj1
>         devid    9 size 3.64TiB used 3.31TiB path /dev/sdb1
>         devid   10 size 3.64TiB used 3.36TiB path /dev/sda1
>         devid   11 size 7.28TiB used 168.00GiB path /dev/sdc1
>         devid   12 size 7.28TiB used 168.00GiB path /dev/sdd1
>
> Last two devices (11 and 12) are the new disks. After adding them, I first
> copied some new data in (about 130 GBs), which seemed to go fine. Then I
> tried to remove disk 5. After some time (about 30 GiBs written to 11 and
> 12), there were some errors and disk 11 or 12 dropped out and fs went
> read-only. After some trouble-shooting (googling), I decided the new disks
> were too iffy to trust and tried to remove them.
>
> I don't remember exactly what errors I got, but device delete operation was
> interrupted due to errors at least once or twice, before more serious
> trouble began. In between the attempts I updated the HBA's (an LSI 9300)
> firmware. After final device delete attempt the end result was that
> attempting to mount causes kernel to crash. I then tried updating kernel and
> running check --repair, but that hasn't helped. Mounting read-only seems to
> work perfectly, but I haven't tried copying everything to /dev/null or
> anything like that (just few files).
>
> The log of the crash (it is very repeatable) can be seen here:
> http://jane.aarghimedes.fi/~jlarja/tempe/btrfs-trouble/btrfs_crash_log.txt
>
> Snipped from start of that:
>
> touko 12 06:41:22 jane kernel: BTRFS info (device sda1): disk space caching
> is enabled
> touko 12 06:41:24 jane kernel: BTRFS info (device sda1): bdev /dev/sdd1
> errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
> touko 12 06:41:39 jane kernel: BUG: unable to handle kernel NULL pointer
> dereference at 00000000000001f0
> touko 12 06:41:39 jane kernel: IP: [<ffffffffc030e0ee>]
> can_overcommit+0x1e/0xf0 [btrfs]
> touko 12 06:41:39 jane kernel: PGD 0
> touko 12 06:41:39 jane kernel: Oops: 0000 [#1] SMP
>
> My dmesg log is here:
> http://jane.aarghimedes.fi/~jlarja/tempe/btrfs-trouble/dmesg.log
>
> Other information:
> Linux jane 4.5.0-1-amd64 #1 SMP Debian 4.5.1-1 (2016-04-14) x86_64 GNU/Linux
> btrfs-progs v4.4.1
>
> btrfs fi df /mnt/Allosaurus/
>     Data, RAID1: total=13.13TiB, used=13.07TiB
>     Data, single: total=8.00MiB, used=0.00B
>     System, RAID1: total=8.00MiB, used=1.94MiB
>     System, single: total=4.00MiB, used=0.00B
>     Metadata, RAID1: total=87.00GiB, used=85.24GiB
>     Metadata, single: total=8.00MiB, used=0.00B
>     GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> The data is either backups or media data dublicated elsewhere, so I'm in no
> great hurry and could just fix everything just with enough new disks and cp
> -R. However, it would save me a lot of trouble (and some money) if I could
> get this fixed otherwise. Of course, would be nice in general for the future
> kernel not to crash when mounting corrupted file system :) .

Indeed kernel should not crash on such a case. It is not clear if you
run a 4.5.1 or 4.5.0 kernel in terms of kernel.org terminology, but
newer than 4.5.x probably does not help in this case.
You could try to mount with usebackuproot and then see if you can get
it writable, after setting long timeout values for the drive. If it
works, then remove those 2 SMRs from the array ASAP.
