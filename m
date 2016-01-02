Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36278 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbcABTWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 14:22:08 -0500
Received: by mail-ig0-f175.google.com with SMTP id ph11so222465336igc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 11:22:07 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 2 Jan 2016 12:22:07 -0700
Message-ID: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
Subject: evidence of persistent state, despite device disconnects
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, I basically do not trust the f'n kernel anymore. I'm having to
reboot in order to get to a (reasonably) deterministic state. Merely
disconnecting devices doesn't  make all aspects of that device and its
filesystem, vanish.

I think this persistence might be causing some Btrfs corruptions that
don't seem to make any sense. Here is one example that I've kept track
of every step of the way:


I have a Btrfs raid1 that fails to mount rw,degraded:
[  174.520303] BTRFS info (device sdc): allowing degraded mounts
[  174.520421] BTRFS info (device sdc): disk space caching is enabled
[  174.520527] BTRFS: has skinny extents
[  174.528060] BTRFS warning (device sdc): devid 1 uuid
94c62352-2568-4abe-8a58-828d1766719c is missing
[  177.924127] BTRFS: missing devices(1) exceeds the limit(0),
writeable mount is not allowed
[  177.950761] BTRFS: open_ctree failed

When mounted -o ro,degraded

[root@f23s ~]# btrfs fi df /mnt/brick2
Data, RAID1: total=502.00GiB, used=499.69GiB
Data, single: total=1.00GiB, used=2.00MiB
System, RAID1: total=32.00MiB, used=80.00KiB
System, single: total=32.00MiB, used=32.00KiB
Metadata, RAID1: total=2.00GiB, used=1008.22MiB
Metadata, single: total=1.00GiB, used=0.00B
GlobalReserve, single: total=352.00MiB, used=0.00B

What the F?

Because the last time it was normal/non-degraded and mounted, the only
chunks were raid1 chunks. Somehow, single chunks have been added and
used without any kernel messages to warn the user they no longer have
a raid1, in effect.

What *exactly* happened since this was an intact raid1 only, 2 device volume?

1. umount /mnt/brick           ##cleanly umounted
2. ## USB cables from the drives disconnected
3. lsblk and blkid see neither of them
4. devid1 is reconnected
5. devid1 is issued ATA security-erase-enhanced command via hdparm
6. devid1 is physically disconnected
7. oldidevid1 is luksformatted and opened
8. devid2 is connected
9.
[root@f23s ~]# lsblk -f
NAME   FSTYPE      LABEL   UUID                                 MOUNTPOINT
sdb    crypto_LUKS         493a7656-8fe6-46e9-88af-a0ffe83ced7e
└─sdb
sdc    btrfs       second  197606b2-9f4a-4742-8824-7fc93285c29c /mnt/brick2

[root@f23s ~]# btrfs fi show /mnt/brick2
Label: 'second'  uuid: 197606b2-9f4a-4742-8824-7fc93285c29c
    Total devices 2 FS bytes used 500.68GiB
    devid    1 size 697.64GiB used 504.03GiB path /dev/sdb
    devid    2 size 697.64GiB used 504.03GiB path /dev/sdc


WTF?! This shouldn't be possible. devid1 is *completely* obliterated.
It was securely erased. It has been luks formatted. It has been
disconnected multiple times (as has devid2). And yet Btrfs sees this
as an intact pair? That's just complete crap. *AND*

It let's me mount it! Not degraded! No error messages!

11. umount /mnt/brick2
12. Reboot
13. btrfs fi show
warning, device 1 is missing
warning devid 1 not found already
Label: 'second'  uuid: 197606b2-9f4a-4742-8824-7fc93285c29c
    Total devices 2 FS bytes used 500.68GiB
    devid    2 size 697.64GiB used 506.06GiB path /dev/sdc
    *** Some devices missing


14. # mount -o degraded, /dev/sdc /mnt/brick2
mount: wrong fs type, bad option, bad superblock on /dev/sdc

and the trace at the very top with bogus missing devices(1) exceeds
the limit(0), writeable mount is not allowed.

So during that not degraded mount of the file system where it saw a
ghost of devid1, it wrote single chunks to devid2. And now devid2 can
only ever be mounted read only. It's impossible to fix it, because I
can't add devices when ro mounted.

Does anyone have any idea what tool to use to explain how the devid1
/dev/sdb, which has been securely erased, luks formatted,
disconnected, reconnected, *STILL* results in Btrfs thinking it's a
valid drive and allowing a non-degraded mount until there's a reboot?
That's really scary.

It's like the btrfs kernel code isn't refreshing its own fs or dev
states when other parts of the kernel know it's gone. Maybe a 'btrfs
dev scan' would have cleared this up, but I shouldn't have to do that
to refresh Btrfs's state anytime I disconnect and connect devices just
to make sure it doesn't sabotage the devices by surreptitiously adding
single chunks to one of the drives!


-- 
Chris Murphy
