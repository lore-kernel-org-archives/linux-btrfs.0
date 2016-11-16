Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:40905 "EHLO
        mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbcKPKeR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 05:34:17 -0500
From: Martin Steigerwald <martin.steigerwald@teamix.de>
To: <linux-btrfs@vger.kernel.org>
CC: Martin <martin@lichtvoll.de>
Subject: degraded BTRFS RAID 1 not mountable: open_ctree failed, unable to find block group for 0
Date: Wed, 16 Nov 2016 11:25:00 +0100
Message-ID: <18970348.FUMEOFOSb3@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

﻿Hello!

A degraded BTRFS RAID 1 from one 3TB SATA HDD of my former workstation is not mountable.

Debian 4.8 kernel + btrfs-tools 4.7.3.

A btrfs restore seems to work well enough, so on one hand there is no
urgency. But on the other hand I want to repurpose the harddisk and I
think I want to do it next weekend. So if you want me to gather some
debug data, please speak up quickly. Thank you.

AFAIR I have been able to mount the filesystems in degraded mode, but
this may have been on the other SATA HDD that I already wiped with shred
command.


I have this:

    merkaba:~> btrfs fi sh
    […]
    warning, device 2 is missing
    warning, device 2 is missing
    warning, device 2 is missing
    Label: 'debian'  uuid: […]
            Total devices 2 FS bytes used 20.10GiB
            devid    1 size 50.00GiB used 29.03GiB path /dev/mapper/satafp1-debian
            *** Some devices missing

    Label: 'daten'  uuid: […]
            Total devices 2 FS bytes used 135.02GiB
            devid    1 size 1.00TiB used 142.06GiB path /dev/mapper/satafp1-daten
            *** Some devices missing

    Label: 'backup'  uuid: […]
            Total devices 2 FS bytes used 88.38GiB
            devid    1 size 1.00TiB used 93.06GiB path /dev/mapper/satafp1-backup
            *** Some devices missing

But none of these filesystems seem to be mountable. Here some attempts:

    merkaba:~#130> LANG=C mount -o degraded /dev/satafp1/backup /mnt/zeit
    mount: wrong fs type, bad option, bad superblock on /dev/mapper/satafp1-daten,
          missing codepage or helper program, or other error

          In some cases useful info is found in syslog - try
          dmesg | tail or so.
    merkaba:~> dmesg | tail -5
    [ 2945.155943] BTRFS info (device dm-13): allowing degraded mounts
    [ 2945.155953] BTRFS info (device dm-13): disk space caching is enabled
    [ 2945.155957] BTRFS info (device dm-13): has skinny extents
    [ 2945.611236] BTRFS warning (device dm-13): missing devices (1) exceeds the limit (0), writeable mount is not allowed
    [ 2945.646719] BTRFS: open_ctree failed


    merkaba:~> LANG=C mount -o usebackuproot /dev/satafp1/daten /mnt/zeit         
    mount: wrong fs type, bad option, bad superblock on /dev/mapper/satafp1-daten,
          missing codepage or helper program, or other error

          In some cases useful info is found in syslog - try
          dmesg | tail or so.
    merkaba:~#32> dmesg | tail -5                                           
    [ 5739.051433] BTRFS info (device dm-12): trying to use backup root at mount time
    [ 5739.051441] BTRFS info (device dm-12): disk space caching is enabled
    [ 5739.051444] BTRFS info (device dm-12): has skinny extents
    [ 5739.103153] BTRFS error (device dm-12): failed to read chunk tree: -5
    [ 5739.130304] BTRFS: open_ctree failed


    merkaba:~> LANG=C mount -o degraded,usebackuproot /dev/satafp1/daten /mnt/zeit
    mount: wrong fs type, bad option, bad superblock on /dev/mapper/satafp1-daten,
          missing codepage or helper program, or other error

          In some cases useful info is found in syslog - try
          dmesg | tail or so.
    merkaba:~#32> dmesg | tail -5                                                    
    [ 5801.704202] BTRFS info (device dm-12): trying to use backup root at mount time
    [ 5801.704206] BTRFS info (device dm-12): disk space caching is enabled
    [ 5801.704208] BTRFS info (device dm-12): has skinny extents
    [ 5803.928059] BTRFS warning (device dm-12): missing devices (1) exceeds the limit (0), writeable mount is not allowed
    [ 5804.064638] BTRFS: open_ctree failed


`btrfs check` reports:

    merkaba:~#32> btrfs check /dev/satafp1/backup 
    warning, device 2 is missing
    Checking filesystem on /dev/satafp1/backup
    UUID: 01cf0493-476f-42e8-8905-61ef205313db
    checking extents
    checking free space cache
    failed to load free space cache for block group 58003030016
    failed to load free space cache for block group 60150513664
    failed to load free space cache for block group 62297997312
    […]
    checking fs roots
    ^C

I aborted it at this time as I wanted to try clear_cache mount option
after seeing this. I can redo this thing after btrfs restore completed.

    merkaba:~> mount -o degraded,clear_cache /dev/satafp1/backup /mnt/zeit
    mount: Falscher Dateisystemtyp, ungültige Optionen, der
    Superblock von /dev/mapper/satafp1-backup ist beschädigt, fehlende
    Kodierungsseite oder ein anderer Fehler

          Manchmal liefert das Systemprotokoll wertvolle Informationen –
          versuchen Sie  dmesg | tail  oder ähnlich
    merkaba:~#32> dmesg | tail -6
    [ 3080.120687] BTRFS info (device dm-13): allowing degraded mounts
    [ 3080.120699] BTRFS info (device dm-13): force clearing of disk cache
    [ 3080.120703] BTRFS info (device dm-13): disk space caching is enabled
    [ 3080.120706] BTRFS info (device dm-13): has skinny extents
    [ 3080.150957] BTRFS warning (device dm-13): missing devices (1) exceeds the limit (0), writeable mount is not allowed
    [ 3080.195941] BTRFS: open_ctree failed

    merkaba:~> mount -o degraded,clear_cache,usebackuproot /dev/satafp1/backup /mnt/zeit
    mount: Falscher Dateisystemtyp, ungültige Optionen, der
    Superblock von /dev/mapper/satafp1-backup ist beschädigt, fehlende
    Kodierungsseite oder ein anderer Fehler

          Manchmal liefert das Systemprotokoll wertvolle Informationen –
          versuchen Sie  dmesg | tail  oder ähnlich

    merkaba:~> dmesg | tail -7
    [ 3173.784713] BTRFS info (device dm-13): allowing degraded mounts
    [ 3173.784728] BTRFS info (device dm-13): force clearing of disk cache
    [ 3173.784737] BTRFS info (device dm-13): trying to use backup root at mount time
    [ 3173.784742] BTRFS info (device dm-13): disk space caching is enabled
    [ 3173.784746] BTRFS info (device dm-13): has skinny extents
    [ 3173.816983] BTRFS warning (device dm-13): missing devices (1) exceeds the limit (0), writeable mount is not allowed
    [ 3173.865199] BTRFS: open_ctree failed

I aborted repairing after this assert:

    merkaba:~#130> btrfs check --repair /dev/satafp1/backup &| stdbuf -oL tee btrfs-check-repair-satafp1-backup.log
    enabling repair mode
    warning, device 2 is missing
    Checking filesystem on /dev/satafp1/backup
    UUID: 01cf0493-476f-42e8-8905-61ef205313db
    checking extents
    Unable to find block group for 0
    extent-tree.c:289: find_search_start: Assertion `1` failed.
    btrfs[0x43e418]
    btrfs(btrfs_reserve_extent+0x5c9)[0x4425df]
    btrfs(btrfs_alloc_free_block+0x63)[0x44297c]
    btrfs(__btrfs_cow_block+0xfc)[0x436636]
    btrfs(btrfs_cow_block+0x8b)[0x436bd8]
    btrfs[0x43ad82]
    btrfs(btrfs_commit_transaction+0xb8)[0x43c5dc]
    btrfs[0x4268b4]
    btrfs(cmd_check+0x1111)[0x427d6d]
    btrfs(main+0x12f)[0x40a341]
    /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fb2e6bec2b1]
    btrfs(_start+0x2a)[0x40a37a]

    merkaba:~#130> btrfs --version
    btrfs-progs v4.7.3

(Honestly I think asserts like this need to be gone from btrfs-tools for good)

About this I only found this unanswered mailing list post:

btrfs-convert: Unable to find block group for 0
Date: Fri, 24 Jun 2016 11:09:27 +0200
https://www.spinics.net/lists/linux-btrfs/msg56478.html


Out of curiosity I tried:

    merkaba:~#1> btrfs rescue zero-log //dev/satafp1/daten
    warning, device 2 is missing
    Clearing log on //dev/satafp1/daten, previous log_root 0, level 0
    Unable to find block group for 0
    extent-tree.c:289: find_search_start: Assertion `1` failed.
    btrfs[0x43e418]
    btrfs(btrfs_reserve_extent+0x5c9)[0x4425df]
    btrfs(btrfs_alloc_free_block+0x63)[0x44297c]
    btrfs(__btrfs_cow_block+0xfc)[0x436636]
    btrfs(btrfs_cow_block+0x8b)[0x436bd8]
    btrfs[0x43ad82]
    btrfs(btrfs_commit_transaction+0xb8)[0x43c5dc]
    btrfs[0x42c0d4]
    btrfs(main+0x12f)[0x40a341]
    /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fb2f16a82b1]
    btrfs(_start+0x2a)[0x40a37a]

(I didn´t expect much as this is an issue that AFAIK does not happen
easily anymore, but I also thought it could not do much harm)

Superblocks themselves seem to be sane:

    merkaba:~#1> btrfs rescue super-recover //dev/satafp1/daten
    All supers are valid, no need to recover

So "btrfs restore" it is:

    merkaba:[…]> btrfs restore -mxs /dev/satafp1/daten daten-restore

This prints out a ton of:

    Trying another mirror
    Trying another mirror

But it actually works. Somewhat, I now just got

    Trying another mirror
    We seem to be looping a lot on daten-restore/[…]/virtualbox-4.1.18-dfsg/out/lib/vboxsoap.a, do you want to keep going on ? (y/N/a):

after about 35 GiB of data restored. I answered no to this one and now it is
at about 53 GiB already. I just got another one of these, but also not 
concerning a file I actually need.

Thanks,

-- 
Martin Steigerwald  | Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller

teamix Support Hotline: +49 911 30999-112
 
 *** Bitte liken Sie uns auf Facebook: facebook.com/teamix ***

