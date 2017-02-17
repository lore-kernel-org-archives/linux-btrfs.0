Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:36532 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934144AbdBQSjp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:39:45 -0500
Received: by mail-yw0-f171.google.com with SMTP id v200so27125349ywc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 10:39:44 -0800 (PST)
Received: from [192.168.1.128] (dhcp-7.rro232.fastlab.unca.edu. [152.18.145.7])
        by smtp.gmail.com with ESMTPSA id a184sm4060733ywf.11.2017.02.17.10.39.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Feb 2017 10:39:43 -0800 (PST)
From: Kenneth Bogert <kbogert@unca.edu>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Subvolume corruption after restart on Raid1 array 
Date: Fri, 17 Feb 2017 13:39:42 -0500
References: <FD81BC09-DB74-45F5-87AD-574E98C80374@unca.edu>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <FD81BC09-DB74-45F5-87AD-574E98C80374@unca.edu>
Message-Id: <C6BE2251-0151-4818-866D-46D68C657DCB@unca.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 11, 2017, at 12:34 PM, Kenneth Bogert <kbogert@unca.edu> wrote:
> 
> Hello all,
> 
> I have been running a Rockstor 3.8.16-8 on an older Dell Optiplex for about a month.  The system has four drives separated into two Raid1 filesystems (“pools” in Rockstor terminology).  A few days ago I restarted it and noticed that the services (NFS, Samba, etc) weren’t working.  Looking at dmesg, I saw:
> 
> kernel: BTRFS error (device sdb): parent transid verify failed on 1721409388544 wanted 19188 found 83121
> 
> and sure enough, one of the subvolumes on my main filesystem is corrupted.  By corrupted I mean it can’t be accessed, deleted, or even looked at:
> 
> ls -l
> kernel: BTRFS error (device sdb): parent transid verify failed on 1721409388544 wanted 19188 found 83121
> kernel: BTRFS error (device sdb): parent transid verify failed on 1721409388544 wanted 19188 found 83121
> ls: cannot access /mnt2/Primary/Movies: Input/output error
> 
> total 16
> drwxr-xr-x 1 root      root         100 Dec 29 02:00 .
> drwxr-xr-x 1 root      root         208 Jan  3 12:05 ..
> drwxr-x--- 1 kbogert   root         698 Feb  6 08:49 Documents
> drwxr-xrwx 1 root      root         916 Jan  3 12:54 Games
> drwxr-xrwx 1 xenserver xenserver   2904 Jan  3 12:54 ISO
> d????????? ? ?         ?              ?            ? Movies
> drwxr-xrwx 1 root      root      139430 Jan  3 12:53 Music
> drwxr-xrwx 1 root      root       82470 Jan  3 12:53 RawPhotos
> drwxr-xr-x 1 root      root          80 Jan  1 04:00 .snapshots
> drwxr-xrwx 1 root      root          72 Jan  3 13:07 VMs
> 
> The input/output error is given for any operation on Movies.
> 
> Luckily there has been no data loss that I am aware of.  As it turns out I have a snapshot of the Movies subvolume taken a few days before the incident.  I was able to simply cp -a all files off of the entire filesystem, with no reported errors, and verified a handful of them.  Note that the transid error in dmesg alternates between sdb and sda5 after each startup.
> 
> 
> SETUP DETAILS
> 
> uname -a
> Linux ironmountain 4.8.7-1.el7.elrepo.x86_64 #1 SMP Thu Nov 10 20:47:24 EST 2016 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs —version
> btrfs-progs v4.8.3
> 
> btrfs dev scan
> kernel: BTRFS: device label Primary devid 1 transid 83461 /dev/sdb
> kernel: BTRFS: device label Primary devid 2 transid 83461 /dev/sda5
> 
> btrfs fi show /mnt2/Primary
> Label: 'Primary'  uuid: 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
> 	Total devices 2 FS bytes used 943.67GiB
> 	devid    1 size 2.73TiB used 947.06GiB path /dev/sdb
> 	devid    2 size 2.70TiB used 947.06GiB path /dev/sda5
> 
> btrfs dev usage /mnt2/Primary
> /dev/sda5, ID: 2
>   Device size:             2.70TiB
>   Device slack:              0.00B
>   Data,RAID1:            944.00GiB
>   Metadata,RAID1:          3.00GiB
>   System,RAID1:           64.00MiB
>   Unallocated:             1.77TiB
> 
> /dev/sdb, ID: 1
>   Device size:             2.73TiB
>   Device slack:              0.00B
>   Data,RAID1:            944.00GiB
>   Metadata,RAID1:          3.00GiB
>   System,RAID1:           64.00MiB
>   Unallocated:             1.80TiB
> 
> 
> btrfs fi df /mnt2/Primary
> Data, RAID1: total=944.00GiB, used=942.60GiB
> System, RAID1: total=64.00MiB, used=176.00KiB
> Metadata, RAID1: total=3.00GiB, used=1.07GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> This server is very light use, however, I do have a number of VMs in the VMs filesystem, exported over NFS, that are used by a Xenserver.  These are not marked nocow, though I probably should have.  At the time of restart no VMs were running.
> 
> I have deviated from Rockstor’s default setup a bit.  They take an “appliance” view and try to enforce btrfs partitions that cover entire disks.  I installed Rockstor onto /dev/sda4, created the Primary partition on /dev/sdb using Rockstor’s gui, then on the command line added /dev/sda5 to it and converted to raid1.  As far as I can tell Rockstor is just CentOS 7 with a few updated utilities and a bunch of python scripts for providing a web interface to btrfs-progs.  I have it setup to take monthly snapshots and do monthly scrubs, with the exception of the Documents subvolume which takes daily snapshots.  These are all readonly and go in the .snapshots directory.  Rockstor automatically deletes old snapshots once a limit is reached (7 daily snapshots, for instance).
> 
> Side note, btrfs-progs 4.8.3 apparently has problems with CentOS 7’s glibc: https://github.com/rockstor/rockstor-core/issues/1608 .  I have confirmed that bug in my own compiled version of 4.8.3, and that 4.9.1 does not have it.
> 
> 
> WHAT I’VE TRIED AND RESULTS
> 
> First off, I have created an image with btrfs-image that I can make available (though large, I believe it was a few Gbs and the filesystem is 3 TB)
> 
> * btrfs-zero-log 
> 	had no discernible effect.
> 
> 
> * At this point, I compiled btrfs-progs 4.9.1.  The following commands were run with this version:
> 
> 
> * btrfs check
> 	This exits in an assert fairly quickly:
> checking extents
> cmds-check.c:5406: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x42139b]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x421483]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x430529]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x43160c]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x435d6f]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x43ab71]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x43b065]
> /mnt/usb/btrfs-progs-bin/bin/btrfs(cmd_check+0xbbc)[0x441b82]
> /mnt/usb/btrfs-progs-bin/bin/btrfs(main+0x12b)[0x40a734]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7ffff6fa7b35]
> /mnt/usb/btrfs-progs-bin/bin/btrfs[0x40a179]
> 
> Full backtrace is attached as btrfsck_debug.log 
> 
> * btrfs check -mode lowmem
> 	This outputs a large number of errors before finally segfault’ing.  Full backtrace attached as btrfsck_lowmem_debug.log
> 
> * btrfs scrub
> 	This completes with no errors.
> 
> 
> * Memtest86 completed more than 6 passes with no errors (left it running for a day)
> 
> * No SMART errors, btrfs device stats shows no errors.  The drives the filesystem is on are brand new.
> 
> * I have tried to recreate the problem by installing Rockstor into a number of VMs and redoing my steps, no such luck.
> 
> 
> The main Rockstor partition (btrfs), as well as the other Raid1 partition on completely separate drives were not affected.  I can provide any other logs requested.
> 
> Help would be greatly appreciated!
> 
> 
> Kenneth Bogert
> 
> <btrfsck_lowmem_debug.log><btrfsck_debug.log>

As a small update to this problem, here is the output of btrfs subvolume list (with 4.9.1):

The snapshot for the Movies subvolume is at gen 73808 but Movies is 19188?


ID 259 gen 83464 cgen 39 parent 5 top level 5 parent_uuid - path Music
ID 260 gen 19188 cgen 40 parent 5 top level 5 parent_uuid - path Movies
ID 261 gen 73808 cgen 41 parent 5 top level 5 parent_uuid - path ISO
ID 262 gen 73864 cgen 42 parent 5 top level 5 parent_uuid - path RawPhotos
ID 263 gen 83456 cgen 44 parent 5 top level 5 parent_uuid - path VMs
ID 601 gen 73810 cgen 356 parent 5 top level 5 parent_uuid - path Games
ID 882 gen 83462 cgen 526 parent 5 top level 5 parent_uuid - path Documents
ID 2104 gen 44513 cgen 44513 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_1
ID 2111 gen 55190 cgen 55190 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_weekly_201701220542
ID 2121 gen 68569 cgen 68569 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_weekly_201701290542
ID 2122 gen 68593 cgen 68593 parent 5 top level 5 parent_uuid 4e131f43-6ccb-7449-89ed-0d00b761cb08 path .snapshots/VMs/VMs_201701290600
ID 2124 gen 71873 cgen 71873 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201701310400
ID 2125 gen 73705 cgen 73705 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702010400
ID 2126 gen 73808 cgen 73808 parent 5 top level 5 parent_uuid 1d82b662-f291-b340-9424-804fa431a03b path .snapshots/ISO/ISO_201702010500
ID 2127 gen 73808 cgen 73808 parent 5 top level 5 parent_uuid 915e8022-4cf3-084b-8ac6-504822a168c4 path .snapshots/Movies/movies_201702010500
ID 2128 gen 73810 cgen 73810 parent 5 top level 5 parent_uuid adcb63c8-ee55-8b49-8f7a-aed491aab7e6 path .snapshots/Games/games_201702010500
ID 2129 gen 73811 cgen 73811 parent 5 top level 5 parent_uuid e23f7432-fc89-c849-a2f2-4280cefabcf7 path .snapshots/Music/music_201702010500
ID 2130 gen 73864 cgen 73864 parent 5 top level 5 parent_uuid 67dc081c-cf8e-a444-8c8f-7899865e2f08 path .snapshots/RawPhotos/rawphotos_201702010530
ID 2131 gen 73865 cgen 73865 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_monthly_201702010530
ID 2132 gen 73920 cgen 73920 parent 5 top level 5 parent_uuid 4e131f43-6ccb-7449-89ed-0d00b761cb08 path .snapshots/VMs/VMs_201702010600
ID 2133 gen 75516 cgen 75516 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702020400
ID 2134 gen 77397 cgen 77397 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702030400
ID 2135 gen 79229 cgen 79229 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702040400
ID 2136 gen 81109 cgen 81109 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702050400
ID 2137 gen 81246 cgen 81246 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_weekly_201702050542
ID 2138 gen 81273 cgen 81273 parent 5 top level 5 parent_uuid 4e131f43-6ccb-7449-89ed-0d00b761cb08 path .snapshots/VMs/VMs_201702050600
ID 2139 gen 82966 cgen 82966 parent 5 top level 5 parent_uuid 212f71b3-21a2-274c-b080-86f262f50ccb path .snapshots/Documents/documents_daily_201702060400


Kenneth Bogert

