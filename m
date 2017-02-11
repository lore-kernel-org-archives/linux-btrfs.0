Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36337 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdBKReZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 12:34:25 -0500
Received: by mail-yw0-f195.google.com with SMTP id q71so4510322ywg.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Feb 2017 09:34:25 -0800 (PST)
Received: from [192.168.1.128] (dhcp-7.rro232.fastlab.unca.edu. [152.18.145.7])
        by smtp.gmail.com with ESMTPSA id h185sm2107978ywh.43.2017.02.11.09.34.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Feb 2017 09:34:23 -0800 (PST)
From: Kenneth Bogert <kbogert@unca.edu>
Content-Type: multipart/mixed;
 boundary="Apple-Mail=_83D61CF0-1B71-45E9-A811-F9F9ACF2FF87"
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Subvolume corruption after restart on Raid1 array 
Message-Id: <FD81BC09-DB74-45F5-87AD-574E98C80374@unca.edu>
Date: Sat, 11 Feb 2017 12:34:22 -0500
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_83D61CF0-1B71-45E9-A811-F9F9ACF2FF87
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello all,

I have been running a Rockstor 3.8.16-8 on an older Dell Optiplex for =
about a month.  The system has four drives separated into two Raid1 =
filesystems (=E2=80=9Cpools=E2=80=9D in Rockstor terminology).  A few =
days ago I restarted it and noticed that the services (NFS, Samba, etc) =
weren=E2=80=99t working.  Looking at dmesg, I saw:

kernel: BTRFS error (device sdb): parent transid verify failed on =
1721409388544 wanted 19188 found 83121

and sure enough, one of the subvolumes on my main filesystem is =
corrupted.  By corrupted I mean it can=E2=80=99t be accessed, deleted, =
or even looked at:

ls -l
kernel: BTRFS error (device sdb): parent transid verify failed on =
1721409388544 wanted 19188 found 83121
kernel: BTRFS error (device sdb): parent transid verify failed on =
1721409388544 wanted 19188 found 83121
ls: cannot access /mnt2/Primary/Movies: Input/output error

total 16
drwxr-xr-x 1 root      root         100 Dec 29 02:00 .
drwxr-xr-x 1 root      root         208 Jan  3 12:05 ..
drwxr-x--- 1 kbogert   root         698 Feb  6 08:49 Documents
drwxr-xrwx 1 root      root         916 Jan  3 12:54 Games
drwxr-xrwx 1 xenserver xenserver   2904 Jan  3 12:54 ISO
d????????? ? ?         ?              ?            ? Movies
drwxr-xrwx 1 root      root      139430 Jan  3 12:53 Music
drwxr-xrwx 1 root      root       82470 Jan  3 12:53 RawPhotos
drwxr-xr-x 1 root      root          80 Jan  1 04:00 .snapshots
drwxr-xrwx 1 root      root          72 Jan  3 13:07 VMs

The input/output error is given for any operation on Movies.

Luckily there has been no data loss that I am aware of.  As it turns out =
I have a snapshot of the Movies subvolume taken a few days before the =
incident.  I was able to simply cp -a all files off of the entire =
filesystem, with no reported errors, and verified a handful of them.  =
Note that the transid error in dmesg alternates between sdb and sda5 =
after each startup.


SETUP DETAILS

uname -a
Linux ironmountain 4.8.7-1.el7.elrepo.x86_64 #1 SMP Thu Nov 10 20:47:24 =
EST 2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs =E2=80=94version
btrfs-progs v4.8.3

btrfs dev scan
kernel: BTRFS: device label Primary devid 1 transid 83461 /dev/sdb
kernel: BTRFS: device label Primary devid 2 transid 83461 /dev/sda5

btrfs fi show /mnt2/Primary
Label: 'Primary'  uuid: 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
	Total devices 2 FS bytes used 943.67GiB
	devid    1 size 2.73TiB used 947.06GiB path /dev/sdb
	devid    2 size 2.70TiB used 947.06GiB path /dev/sda5

btrfs dev usage /mnt2/Primary
/dev/sda5, ID: 2
   Device size:             2.70TiB
   Device slack:              0.00B
   Data,RAID1:            944.00GiB
   Metadata,RAID1:          3.00GiB
   System,RAID1:           64.00MiB
   Unallocated:             1.77TiB

/dev/sdb, ID: 1
   Device size:             2.73TiB
   Device slack:              0.00B
   Data,RAID1:            944.00GiB
   Metadata,RAID1:          3.00GiB
   System,RAID1:           64.00MiB
   Unallocated:             1.80TiB


btrfs fi df /mnt2/Primary
Data, RAID1: total=3D944.00GiB, used=3D942.60GiB
System, RAID1: total=3D64.00MiB, used=3D176.00KiB
Metadata, RAID1: total=3D3.00GiB, used=3D1.07GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


This server is very light use, however, I do have a number of VMs in the =
VMs filesystem, exported over NFS, that are used by a Xenserver.  These =
are not marked nocow, though I probably should have.  At the time of =
restart no VMs were running.

I have deviated from Rockstor=E2=80=99s default setup a bit.  They take =
an =E2=80=9Cappliance=E2=80=9D view and try to enforce btrfs partitions =
that cover entire disks.  I installed Rockstor onto /dev/sda4, created =
the Primary partition on /dev/sdb using Rockstor=E2=80=99s gui, then on =
the command line added /dev/sda5 to it and converted to raid1.  As far =
as I can tell Rockstor is just CentOS 7 with a few updated utilities and =
a bunch of python scripts for providing a web interface to btrfs-progs.  =
I have it setup to take monthly snapshots and do monthly scrubs, with =
the exception of the Documents subvolume which takes daily snapshots.  =
These are all readonly and go in the .snapshots directory.  Rockstor =
automatically deletes old snapshots once a limit is reached (7 daily =
snapshots, for instance).

Side note, btrfs-progs 4.8.3 apparently has problems with CentOS 7=E2=80=99=
s glibc: https://github.com/rockstor/rockstor-core/issues/1608 .  I have =
confirmed that bug in my own compiled version of 4.8.3, and that 4.9.1 =
does not have it.


WHAT I=E2=80=99VE TRIED AND RESULTS

First off, I have created an image with btrfs-image that I can make =
available (though large, I believe it was a few Gbs and the filesystem =
is 3 TB)

* btrfs-zero-log=20
	had no discernible effect.


* At this point, I compiled btrfs-progs 4.9.1.  The following commands =
were run with this version:


* btrfs check
	This exits in an assert fairly quickly:
checking extents
cmds-check.c:5406: check_owner_ref: BUG_ON `rec->is_root` triggered, =
value 1
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x42139b]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x421483]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x430529]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x43160c]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x435d6f]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x43ab71]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x43b065]
/mnt/usb/btrfs-progs-bin/bin/btrfs(cmd_check+0xbbc)[0x441b82]
/mnt/usb/btrfs-progs-bin/bin/btrfs(main+0x12b)[0x40a734]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7ffff6fa7b35]
/mnt/usb/btrfs-progs-bin/bin/btrfs[0x40a179]

Full backtrace is attached as btrfsck_debug.log=20

* btrfs check -mode lowmem
	This outputs a large number of errors before finally =
segfault=E2=80=99ing.  Full backtrace attached as =
btrfsck_lowmem_debug.log

* btrfs scrub
	This completes with no errors.


* Memtest86 completed more than 6 passes with no errors (left it running =
for a day)

* No SMART errors, btrfs device stats shows no errors.  The drives the =
filesystem is on are brand new.

* I have tried to recreate the problem by installing Rockstor into a =
number of VMs and redoing my steps, no such luck.


The main Rockstor partition (btrfs), as well as the other Raid1 =
partition on completely separate drives were not affected.  I can =
provide any other logs requested.

Help would be greatly appreciated!


Kenneth Bogert


--Apple-Mail=_83D61CF0-1B71-45E9-A811-F9F9ACF2FF87
Content-Disposition: attachment;
	filename=btrfsck_lowmem_debug.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="btrfsck_lowmem_debug.log"
Content-Transfer-Encoding: 7bit

Starting program: /mnt/usb/btrfs-progs-bin/bin/./btrfs check --mode lowmem /dev/sdb
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

checking extents
ERROR: extent[920236044288, 94208] referencer count mismatch (root: 263, owner: 285, offset: 383730442240) wanted: 1, have: 0
ERROR: bad extent[962529853440, 962529869824) type mismatch with chunk
ERROR: block group[962127200256 1073741824] used 1073737728 but extent items used 1201360896
ERROR: block group[1031920418816 1073741824] used 1073741824 but extent items used 1207959552
ERROR: extent[1149865406464, 134217728] referencer count mismatch (root: 263, owner: 285, offset: 117903826944) wanted: 15, have: 0
ERROR: extent[1184660193280, 134217728] referencer count mismatch (root: 263, owner: 285, offset: 82109140992) wanted: 12, have: 0
ERROR: extent[1191627235328, 134217728] referencer count mismatch (root: 263, owner: 287, offset: 58824290304) wanted: 26, have: 78
ERROR: extent[1314269351936, 36610048] referencer count mismatch (root: 263, owner: 287, offset: 42139648) wanted: 96, have: 157
ERROR: extent[1342215913472, 32768] referencer count mismatch (root: 263, owner: 285, offset: 249278464) wanted: 1, have: 0
parent transid verify failed on 1721409388544 wanted 19188 found 83121
parent transid verify failed on 1721409388544 wanted 19188 found 83121
parent transid verify failed on 1721409388544 wanted 19188 found 83121
parent transid verify failed on 1721409388544 wanted 19188 found 83121
Ignoring transid failure
ERROR: extent[1362632900608, 134217728] referencer count mismatch (root: 260, owner: 635, offset: 0) wanted: 1, have: 0
ERROR: extent[1362767118336, 134217728] referencer count mismatch (root: 260, owner: 635, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1362901336064, 64294912] referencer count mismatch (root: 260, owner: 635, offset: 268435456) wanted: 1, have: 0
ERROR: extent[1363706642432, 45211648] referencer count mismatch (root: 260, owner: 615, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1363751854080, 45244416] referencer count mismatch (root: 260, owner: 618, offset: 45182976) wanted: 1, have: 0
ERROR: extent[1363797098496, 25137152] referencer count mismatch (root: 260, owner: 619, offset: 0) wanted: 1, have: 0
ERROR: extent[1363822235648, 42364928] referencer count mismatch (root: 260, owner: 620, offset: 0) wanted: 1, have: 0
ERROR: extent[1363864600576, 16969728] referencer count mismatch (root: 260, owner: 621, offset: 0) wanted: 1, have: 0
ERROR: extent[1363881570304, 36491264] referencer count mismatch (root: 260, owner: 622, offset: 0) wanted: 1, have: 0
ERROR: extent[1363918061568, 134217728] referencer count mismatch (root: 260, owner: 623, offset: 0) wanted: 1, have: 0
ERROR: extent[1364052279296, 134217728] referencer count mismatch (root: 260, owner: 623, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1364186497024, 61194240] referencer count mismatch (root: 260, owner: 623, offset: 268435456) wanted: 1, have: 0
ERROR: extent[1364247691264, 134217728] referencer count mismatch (root: 260, owner: 623, offset: 329629696) wanted: 1, have: 0
ERROR: extent[1364381908992, 19877888] referencer count mismatch (root: 260, owner: 625, offset: 0) wanted: 1, have: 0
ERROR: extent[1364401786880, 42758144] referencer count mismatch (root: 260, owner: 626, offset: 0) wanted: 1, have: 0
ERROR: extent[1364444545024, 18350080] referencer count mismatch (root: 260, owner: 627, offset: 0) wanted: 1, have: 0
ERROR: extent[1364462895104, 1572864] referencer count mismatch (root: 260, owner: 627, offset: 18350080) wanted: 1, have: 0
ERROR: extent[1364464467968, 120848384] referencer count mismatch (root: 260, owner: 623, offset: 463847424) wanted: 1, have: 0
ERROR: extent[1364585316352, 26787840] referencer count mismatch (root: 260, owner: 627, offset: 19922944) wanted: 1, have: 0
ERROR: extent[1364612104192, 17178624] referencer count mismatch (root: 260, owner: 628, offset: 0) wanted: 1, have: 0
ERROR: extent[1364629282816, 18063360] referencer count mismatch (root: 260, owner: 629, offset: 0) wanted: 1, have: 0
ERROR: extent[1364647346176, 18382848] referencer count mismatch (root: 260, owner: 630, offset: 0) wanted: 1, have: 0
ERROR: extent[1364665729024, 36315136] referencer count mismatch (root: 260, owner: 633, offset: 0) wanted: 1, have: 0
ERROR: extent[1364702044160, 18718720] referencer count mismatch (root: 260, owner: 634, offset: 0) wanted: 1, have: 0
ERROR: extent[1364780384256, 134217728] referencer count mismatch (root: 260, owner: 608, offset: 0) wanted: 1, have: 0
ERROR: extent[1364914601984, 131919872] referencer count mismatch (root: 260, owner: 609, offset: 0) wanted: 1, have: 0
ERROR: extent[1365046521856, 17911808] referencer count mismatch (root: 260, owner: 608, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1365064433664, 134217728] referencer count mismatch (root: 260, owner: 609, offset: 131919872) wanted: 1, have: 0
ERROR: extent[1365198651392, 524288] referencer count mismatch (root: 260, owner: 609, offset: 266137600) wanted: 1, have: 0
ERROR: extent[1365199175680, 134217728] referencer count mismatch (root: 260, owner: 609, offset: 266661888) wanted: 1, have: 0
ERROR: extent[1365333393408, 61112320] referencer count mismatch (root: 260, owner: 612, offset: 0) wanted: 1, have: 0
ERROR: extent[1365394505728, 124956672] referencer count mismatch (root: 260, owner: 613, offset: 0) wanted: 1, have: 0
ERROR: extent[1365519462400, 36802560] referencer count mismatch (root: 260, owner: 609, offset: 400879616) wanted: 1, have: 0
ERROR: extent[1365556264960, 134217728] referencer count mismatch (root: 260, owner: 615, offset: 0) wanted: 1, have: 0
ERROR: extent[1365690482688, 102158336] referencer count mismatch (root: 260, owner: 617, offset: 0) wanted: 1, have: 0
ERROR: extent[1365792641024, 45182976] referencer count mismatch (root: 260, owner: 618, offset: 0) wanted: 1, have: 0
ERROR: extent[1365837824000, 12677120] referencer count mismatch (root: 260, owner: 636, offset: 0) wanted: 1, have: 0
ERROR: extent[1366576902144, 21778432] referencer count mismatch (root: 260, owner: 602, offset: 0) wanted: 1, have: 0
ERROR: extent[1366598680576, 37376000] referencer count mismatch (root: 260, owner: 603, offset: 0) wanted: 1, have: 0
ERROR: extent[1366636056576, 26660864] referencer count mismatch (root: 260, owner: 604, offset: 0) wanted: 1, have: 0
ERROR: extent[1366662717440, 54575104] referencer count mismatch (root: 260, owner: 605, offset: 0) wanted: 1, have: 0
ERROR: extent[1366717292544, 35958784] referencer count mismatch (root: 260, owner: 606, offset: 0) wanted: 1, have: 0
ERROR: extent[1366753251328, 55410688] referencer count mismatch (root: 260, owner: 607, offset: 0) wanted: 1, have: 0
ERROR: extent[1366808662016, 37933056] referencer count mismatch (root: 260, owner: 610, offset: 0) wanted: 1, have: 0
ERROR: extent[1366846595072, 66609152] referencer count mismatch (root: 260, owner: 611, offset: 0) wanted: 1, have: 0
ERROR: extent[1366913204224, 10575872] referencer count mismatch (root: 260, owner: 624, offset: 0) wanted: 1, have: 0
ERROR: extent[1369064730624, 9703424] referencer count mismatch (root: 260, owner: 616, offset: 0) wanted: 1, have: 0
ERROR: extent[1370136272896, 8892416] referencer count mismatch (root: 260, owner: 614, offset: 0) wanted: 1, have: 0
ERROR: extent[1379804876800, 7684096] referencer count mismatch (root: 260, owner: 631, offset: 0) wanted: 1, have: 0
ERROR: extent[1395916967936, 1855488] referencer count mismatch (root: 260, owner: 632, offset: 0) wanted: 1, have: 0
ERROR: extent[1422762442752, 134217728] referencer count mismatch (root: 260, owner: 261, offset: 380166144) wanted: 1, have: 0
ERROR: extent[1422896660480, 134217728] referencer count mismatch (root: 260, owner: 261, offset: 514383872) wanted: 1, have: 0
ERROR: extent[1423030878208, 53112832] referencer count mismatch (root: 260, owner: 261, offset: 648601600) wanted: 1, have: 0
ERROR: extent[1423836184576, 90234880] referencer count mismatch (root: 260, owner: 260, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1423926419456, 134217728] referencer count mismatch (root: 260, owner: 260, offset: 224452608) wanted: 1, have: 0
ERROR: extent[1424060637184, 134217728] referencer count mismatch (root: 260, owner: 260, offset: 358670336) wanted: 1, have: 0
ERROR: extent[1424194854912, 134217728] referencer count mismatch (root: 260, owner: 260, offset: 492888064) wanted: 1, have: 0
ERROR: extent[1424329072640, 67043328] referencer count mismatch (root: 260, owner: 260, offset: 665370624) wanted: 1, have: 0
ERROR: extent[1424396115968, 134217728] referencer count mismatch (root: 260, owner: 261, offset: 0) wanted: 1, have: 0
ERROR: extent[1424530333696, 134217728] referencer count mismatch (root: 260, owner: 261, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1424664551424, 111730688] referencer count mismatch (root: 260, owner: 261, offset: 268435456) wanted: 1, have: 0
ERROR: extent[1424776282112, 50331648] referencer count mismatch (root: 260, owner: 262, offset: 16777216) wanted: 1, have: 0
ERROR: extent[1424826613760, 102400] referencer count mismatch (root: 260, owner: 262, offset: 67108864) wanted: 1, have: 0
ERROR: extent[1424909926400, 134217728] referencer count mismatch (root: 260, owner: 258, offset: 535924736) wanted: 1, have: 0
ERROR: extent[1425044144128, 64847872] referencer count mismatch (root: 260, owner: 258, offset: 670142464) wanted: 1, have: 0
ERROR: extent[1425108992000, 134217728] referencer count mismatch (root: 260, owner: 259, offset: 50335744) wanted: 1, have: 0
ERROR: extent[1425243209728, 134217728] referencer count mismatch (root: 260, owner: 259, offset: 184553472) wanted: 1, have: 0
ERROR: extent[1425377427456, 134217728] referencer count mismatch (root: 260, owner: 259, offset: 318771200) wanted: 1, have: 0
ERROR: extent[1425511645184, 107479040] referencer count mismatch (root: 260, owner: 259, offset: 452988928) wanted: 1, have: 0
ERROR: extent[1425619124224, 134217728] referencer count mismatch (root: 260, owner: 259, offset: 560467968) wanted: 1, have: 0
ERROR: extent[1425753341952, 134217728] referencer count mismatch (root: 260, owner: 260, offset: 0) wanted: 1, have: 0
ERROR: extent[1425887559680, 52764672] referencer count mismatch (root: 260, owner: 259, offset: 694685696) wanted: 1, have: 0
ERROR: extent[1425940324352, 36556800] referencer count mismatch (root: 260, owner: 260, offset: 627105792) wanted: 1, have: 0
ERROR: extent[1425976881152, 1572864] referencer count mismatch (root: 260, owner: 260, offset: 663662592) wanted: 1, have: 0
ERROR: extent[1425978454016, 45056] referencer count mismatch (root: 260, owner: 260, offset: 665235456) wanted: 1, have: 0
ERROR: extent[1425978499072, 45056] referencer count mismatch (root: 260, owner: 260, offset: 665280512) wanted: 1, have: 0
ERROR: extent[1425978544128, 45056] referencer count mismatch (root: 260, owner: 260, offset: 665325568) wanted: 1, have: 0
ERROR: extent[1426425278464, 134217728] referencer count mismatch (root: 260, owner: 258, offset: 0) wanted: 1, have: 0
ERROR: extent[1426559496192, 134217728] referencer count mismatch (root: 260, owner: 258, offset: 134217728) wanted: 1, have: 0
ERROR: extent[1426693713920, 133271552] referencer count mismatch (root: 260, owner: 258, offset: 268435456) wanted: 1, have: 0
ERROR: extent[1426826985472, 134217728] referencer count mismatch (root: 260, owner: 258, offset: 401707008) wanted: 1, have: 0
ERROR: extent[1426961203200, 5767168] referencer count mismatch (root: 260, owner: 259, offset: 0) wanted: 1, have: 0
ERROR: extent[1426966970368, 41947136] referencer count mismatch (root: 260, owner: 259, offset: 5767168) wanted: 1, have: 0
ERROR: extent[1427008917504, 2621440] referencer count mismatch (root: 260, owner: 259, offset: 47714304) wanted: 1, have: 0
ERROR: extent[1427011538944, 16777216] referencer count mismatch (root: 260, owner: 262, offset: 0) wanted: 1, have: 0
ERROR: extent[1565151039488, 32792576] referencer count mismatch (root: 263, owner: 269, offset: 11210354688) wanted: 1, have: 2
ERROR: extent[1567492001792, 72192000] referencer count mismatch (root: 263, owner: 270, offset: 10980872192) wanted: 1, have: 2
ERROR: extent[1642516774912, 106496] referencer count mismatch (root: 263, owner: 285, offset: 6510891008) wanted: 1, have: 0
ERROR: extent[1678035034112, 16814080] referencer count mismatch (root: 263, owner: 265, offset: 298381312) wanted: 9, have: 11
ERROR: extent[1678051848192, 29622272] referencer count mismatch (root: 263, owner: 277, offset: 19943424) wanted: 6, have: 12
ERROR: extent[1681014620160, 14217216] referencer count mismatch (root: 263, owner: 261, offset: 727629824) wanted: 1, have: 2
ERROR: extent[1682221711360, 28377088] referencer count mismatch (root: 263, owner: 267, offset: 67256320) wanted: 1, have: 2
ERROR: block group[1700861575168 1073741824] used 1073741824 but extent items used 0
ERROR: extent [1719302012928 16384] referencer bytenr mismatch, wanted: 1719302012928, have: 1721409388544
ERROR: extent [1719372939264 16384] referencer bytenr mismatch, wanted: 1719372939264, have: 1721409388544
ERROR: extent [1719422746624 16384] referencer bytenr mismatch, wanted: 1719422746624, have: 1721409388544
ERROR: extent [1719431282688 16384] referencer bytenr mismatch, wanted: 1719431282688, have: 1721409388544
ERROR: extent [1719481237504 16384] referencer bytenr mismatch, wanted: 1719481237504, have: 1721409388544
ERROR: extent [1719617585152 16384] referencer bytenr mismatch, wanted: 1719617585152, have: 1721409388544
ERROR: extent [1719657889792 16384] referencer bytenr mismatch, wanted: 1719657889792, have: 1721409388544
ERROR: extent [1719743889408 16384] referencer bytenr mismatch, wanted: 1719743889408, have: 1721409388544
ERROR: extent [1719759962112 16384] referencer bytenr mismatch, wanted: 1719759962112, have: 1721409388544
ERROR: extent [1719869472768 16384] referencer bytenr mismatch, wanted: 1719869472768, have: 1721409388544
ERROR: extent [1719869489152 16384] referencer bytenr mismatch, wanted: 1719869489152, have: 1721409388544
ERROR: extent [1719916314624 16384] referencer bytenr mismatch, wanted: 1719916314624, have: 1721409388544
ERROR: extent [1719918362624 16384] referencer bytenr mismatch, wanted: 1719918362624, have: 1721409388544
ERROR: extent [1719919640576 16384] referencer bytenr mismatch, wanted: 1719919640576, have: 1721409388544
ERROR: extent [1721409404928 16384] referencer bytenr mismatch, wanted: 1721409404928, have: 1721409388544
ERROR: extent [1721409421312 16384] referencer bytenr mismatch, wanted: 1721409421312, have: 1721409388544
ERROR: extent [1721415778304 16384] referencer bytenr mismatch, wanted: 1721415778304, have: 1721409388544


Program received signal SIGSEGV, Segmentation fault.
0x00000000004229d4 in btrfs_header_bytenr (eb=0x0) at ctree.h:1982
1982	ctree.h: No such file or directory.

bt
#0  0x00000000004229d4 in btrfs_header_bytenr (eb=0x0) at ctree.h:1982
#1  0x000000000043c510 in check_tree_block_backref (fs_info=0x6f5400, root_id=260, bytenr=1721460621312, level=1) at cmds-check.c:10415
#2  0x000000000043cf7f in check_extent_item (fs_info=0x6f5400, eb=0x777ac0, slot=73) at cmds-check.c:10748
#3  0x000000000043e059 in check_leaf_items (root=0x6f58b0, eb=0x777ac0) at cmds-check.c:11188
#4  0x000000000043e616 in traverse_tree_block (root=0x6f58b0, node=0x777ac0) at cmds-check.c:11369
#5  0x000000000043e741 in traverse_tree_block (root=0x6f58b0, node=0x773a30) at cmds-check.c:11394
#6  0x000000000043e741 in traverse_tree_block (root=0x6f58b0, node=0x71e500) at cmds-check.c:11394
#7  0x000000000043e946 in check_chunks_and_extents_v2 (root=0x76ded0) at cmds-check.c:11450
#8  0x0000000000441b71 in cmd_check (argc=4, argv=0x7fffffffe710) at cmds-check.c:12916
#9  0x000000000040a734 in main (argc=4, argv=0x7fffffffe710) at btrfs.c:243

bt full
#0  0x00000000004229d4 in btrfs_header_bytenr (eb=0x0) at ctree.h:1982
        h = 0x80
#1  0x000000000043c510 in check_tree_block_backref (fs_info=0x6f5400, root_id=260, bytenr=1721460621312, level=1) at cmds-check.c:10415
        root = 0x76ed10
        key = {objectid = 256, type = 1 '\001', offset = 0}
        path = {nodes = {0x78fe20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {0, 0, 0, 0, 0, 0, 0, 0}, reada = 0 '\000', lowest_level = 1 '\001', search_for_split = 0 '\000', skip_check_block = 0 '\000'}
        eb = 0x7f38c0
        node = 0x0
        nodesize = 16384
        err = 0
        ret = 1
#2  0x000000000043cf7f in check_extent_item (fs_info=0x6f5400, eb=0x777ac0, slot=73) at cmds-check.c:10748
        ei = 0x3649
        iref = 0x3661
        dref = 0x777ac0
        end = 13930
        ptr = 13921
        type = 176
        nodesize = 16384
        item_size = 33
        flags = 2
        offset = 260
        metadata = 1
        level = 1
        key = {objectid = 1721460621312, type = 169 '\251', offset = 1}
        ret = 32767
        err = 0
#3  0x000000000043e059 in check_leaf_items (root=0x6f58b0, eb=0x777ac0) at cmds-check.c:11188
        fs_info = 0x6f5400
        key = {objectid = 1721460621312, type = 169 '\251', offset = 1}
        slot = 73
        type = 169
        dref = 0x400000000000
        ret = 0
        err = 0
#4  0x000000000043e616 in traverse_tree_block (root=0x6f58b0, node=0x777ac0) at cmds-check.c:11369
        eb = 0x0
        key = {objectid = 70373039137536, type = 0 '\000', offset = 16}
        drop_key = {objectid = 1719154917376, type = 0 '\000', offset = 16140901064495886164}
        level = 0
        nr = 4338842
        i = 32767
        err = 0
        ret = 0
#5  0x000000000043e741 in traverse_tree_block (root=0x6f58b0, node=0x773a30) at cmds-check.c:11394
        blocknr = 1719154917376
        eb = 0x777ac0
        key = {objectid = 1721451741184, type = 169 '\251', offset = 0}
        drop_key = {objectid = 0, type = 0 '\000', offset = 0}
        level = 1
        nr = 244
        i = 137
        err = 16
        ret = 0
#6  0x000000000043e741 in traverse_tree_block (root=0x6f58b0, node=0x71e500) at cmds-check.c:11394
        blocknr = 1897538420736
        eb = 0x773a30
        key = {objectid = 1719730520064, type = 169 '\251', offset = 0}
        drop_key = {objectid = 0, type = 0 '\000', offset = 0}
        level = 2
        nr = 6
        i = 3
        err = 408
        ret = 152
#7  0x000000000043e946 in check_chunks_and_extents_v2 (root=0x76ded0) at cmds-check.c:11450
        path = {nodes = {0x76f9a0, 0x71a470, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {0, 0, 0, 0, 0, 0, 0, 0}, reada = 0 '\000', lowest_level = 0 '\000', search_for_split = 0 '\000', skip_check_block = 0 '\000'}
        key = {objectid = 2, type = 132 '\204', offset = 18446744073709551615}
        root1 = 0x6f5650
        cur_root = 0x6f58b0
        err = 0
        ret = 0
#8  0x0000000000441b71 in cmd_check (argc=4, argv=0x7fffffffe710) at cmds-check.c:12916
        root_cache = {root = {rb_node = 0x0}}
        root = 0x76ded0
        info = 0x6f5400
        bytenr = 0
        subvolid = 0
        tree_root_bytenr = 0
        chunk_root_bytenr = 0
        uuidbuf = "21e09dd8-a54d-49ec-95cb-93fdd94f0c17"
        ret = 0
        err = 0
        num = 140737488348592
        init_csum_tree = 0
        readonly = 0
        clear_space_cache = 0
        qgroup_report = 0
        qgroups_repaired = 0
        ctree_flags = 64
#9  0x000000000040a734 in main (argc=4, argv=0x7fffffffe710) at btrfs.c:243
        cmd = 0x6ec878
        bname = 0x7fffffffe91f "btrfs"
        ret = 0

info locals
cmd = 0x6ec878
bname = 0x7fffffffe91f "btrfs"
ret = 0

--Apple-Mail=_83D61CF0-1B71-45E9-A811-F9F9ACF2FF87
Content-Disposition: attachment;
	filename=btrfsck_debug.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="btrfsck_debug.log"
Content-Transfer-Encoding: 7bit

Starting program: /mnt/usb/btrfs-progs-bin/bin/btrfs check /dev/sdb 2> /root/btrfsck_debug.out
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

Program received signal SIGABRT, Aborted.
0x00007ffff6fbb1d7 in raise () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install glibc-2.17-157.el7_3.1.x86_64 libblkid-2.23.2-33.el7.x86_64 libgcc-4.8.5-11.el7.x86_64 libuuid-2.23.2-33.el7.x86_64 lzo-2.06-8.el7.x86_64 zlib-1.2.7-17.el7.x86_64

bt
#0  0x00007ffff6fbb1d7 in raise () from /lib64/libc.so.6
#1  0x00007ffff6fbc8c8 in abort () from /lib64/libc.so.6
#2  0x0000000000421488 in bugon_trace (assertion=0x4ba0c7 "rec->is_root", filename=0x4b8c11 "cmds-check.c", func=0x4bd2b0 <__func__.12564> "check_owner_ref", line=5406, val=1) at kerncompat.h:115
#3  0x0000000000430529 in check_owner_ref (root=0x76ded0, rec=0x820270, buf=0xce9860) at cmds-check.c:5406
#4  0x000000000043160c in check_block (root=0x76ded0, extent_cache=0x7fffffffe430, buf=0xce9860, flags=0) at cmds-check.c:5809
#5  0x0000000000435d6f in run_next_block (root=0x76ded0, bits=0x76f9a0, bits_nr=1024, last=0x7fffffffe0a8, pending=0x7fffffffe410, seen=0x7fffffffe420, reada=0x7fffffffe400, nodes=0x7fffffffe3f0, extent_cache=0x7fffffffe430, 
    chunk_cache=0x7fffffffe490, dev_cache=0x7fffffffe4a0, block_group_cache=0x7fffffffe470, dev_extent_cache=0x7fffffffe440, ri=0x76e3b0) at cmds-check.c:7655
#6  0x000000000043ab71 in deal_root_from_list (list=0x7fffffffe120, root=0x76ded0, bits=0x76f9a0, bits_nr=1024, pending=0x7fffffffe410, seen=0x7fffffffe420, reada=0x7fffffffe400, nodes=0x7fffffffe3f0, extent_cache=0x7fffffffe430, 
    chunk_cache=0x7fffffffe490, dev_cache=0x7fffffffe4a0, block_group_cache=0x7fffffffe470, dev_extent_cache=0x7fffffffe440) at cmds-check.c:9721
#7  0x000000000043b065 in check_chunks_and_extents (root=0x76ded0) at cmds-check.c:9888
#8  0x0000000000441b82 in cmd_check (argc=2, argv=0x7fffffffe740) at cmds-check.c:12918
#9  0x000000000040a734 in main (argc=2, argv=0x7fffffffe740) at btrfs.c:243

bt full
#0  0x00007ffff6fbb1d7 in raise () from /lib64/libc.so.6
No symbol table info available.
#1  0x00007ffff6fbc8c8 in abort () from /lib64/libc.so.6
No symbol table info available.
#2  0x0000000000421488 in bugon_trace (assertion=0x4ba0c7 "rec->is_root", filename=0x4b8c11 "cmds-check.c", func=0x4bd2b0 <__func__.12564> "check_owner_ref", line=5406, val=1) at kerncompat.h:115
No locals.
#3  0x0000000000430529 in check_owner_ref (root=0x76ded0, rec=0x820270, buf=0xce9860) at cmds-check.c:5406
        node = 0x820270
        back = 0x73eb30
        ref_root = 0x190cbfec000
        key = {objectid = 140737488346496, type = 96 '`', offset = 14987979559889063576}
        path = {nodes = {0xce9860, 0xceaa11, 0x1131, 0x7fffffffdd00, 0x459201 <btrfs_item_end+57>, 0x1131, 0xce9860, 0x1a0c}, slots = {-8928, 32767, 4559413, 0, -8960, 172, 13539424, 0}, reada = -96 '\240', lowest_level = 221 '\335', 
          search_for_split = 255 '\377', skip_check_block = 255 '\377'}
        parent = 0xff9b400000
        level = 7
        found = 0
        ret = 148897960
        __func__ = "check_owner_ref"
#4  0x000000000043160c in check_block (root=0x76ded0, extent_cache=0x7fffffffe430, buf=0xce9860, flags=0) at cmds-check.c:5809
        rec = 0x820270
        cache = 0x8202a0
        key = {objectid = 1094746275840, type = 168 '\250', offset = 20480}
        status = BTRFS_TREE_BLOCK_CLEAN
        ret = 0
        level = 0
#5  0x0000000000435d6f in run_next_block (root=0x76ded0, bits=0x76f9a0, bits_nr=1024, last=0x7fffffffe0a8, pending=0x7fffffffe410, seen=0x7fffffffe420, reada=0x7fffffffe400, nodes=0x7fffffffe3f0, extent_cache=0x7fffffffe430, 
    chunk_cache=0x7fffffffe490, dev_cache=0x7fffffffe4a0, block_group_cache=0x7fffffffe470, dev_extent_cache=0x7fffffffe440, ri=0x76e3b0) at cmds-check.c:7655
        buf = 0xce9860
        rec = 0x820270
        bytenr = 1721409388544
        size = 16384
        parent = 0
        owner = 2
        flags = 0
        ptr = 0
        gen = 0
        ret = 0
        i = 1
        nritems = 173
        key = {objectid = 0, type = 0 '\000', offset = 0}
        cache = 0x8202a0
        reada_bits = 0
#6  0x000000000043ab71 in deal_root_from_list (list=0x7fffffffe120, root=0x76ded0, bits=0x76f9a0, bits_nr=1024, pending=0x7fffffffe410, seen=0x7fffffffe420, reada=0x7fffffffe400, nodes=0x7fffffffe3f0, extent_cache=0x7fffffffe430, 
    chunk_cache=0x7fffffffe490, dev_cache=0x7fffffffe4a0, block_group_cache=0x7fffffffe470, dev_extent_cache=0x7fffffffe440) at cmds-check.c:9721
        rec = 0x76e3b0
        buf = 0xce9860
        ret = 0
        last = 1721409388544
#7  0x000000000043b065 in check_chunks_and_extents (root=0x76ded0) at cmds-check.c:9888
        dev_cache = {rb_node = 0x6fba90}
        chunk_cache = {root = {rb_node = 0x7c70f0}}
        block_group_cache = {tree = {root = {rb_node = 0x1abad10}}, block_groups = {next = 0x8aab70, prev = 0x619aa70}}
        dev_extent_cache = {tree = {root = {rb_node = 0x61ac3e0}}, no_chunk_orphans = {next = 0x4451f50, prev = 0x61e57d0}, no_device_orphans = {next = 0x4451f60, prev = 0x61e57e0}}
        extent_cache = {root = {rb_node = 0xaa4ee0}}
        seen = {root = {rb_node = 0x6258810}}
        pending = {root = {rb_node = 0x0}}
        reada = {root = {rb_node = 0x0}}
        nodes = {root = {rb_node = 0x0}}
        excluded_extents = {state = {root = {rb_node = 0x0}}, cache = {root = {rb_node = 0x0}}, lru = {next = 0x7fffffffe3d0, prev = 0x7fffffffe3d0}, cache_size = 0}
        corrupt_blocks = {root = {rb_node = 0x0}}
        path = {nodes = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, slots = {0, 0, 0, 0, 0, 0, 0, 0}, reada = 0 '\000', lowest_level = 0 '\000', search_for_split = 0 '\000', skip_check_block = 0 '\000'}
        key = {objectid = 0, type = 132 '\204', offset = 0}
        found_key = {objectid = 18446744073709551607, type = 132 '\204', offset = 0}
        ret = 1
        err = 0
        bits = 0x76f9a0
        bits_nr = 1024
        leaf = 0x7739b0
        slot = 210
        ri = {inode = {generation = 1, transid = 0, size = 3, nbytes = 16384, block_group = 0, nlink = 1, uid = 0, gid = 0, mode = 16877, rdev = 0, flags = 18446744071562067968, sequence = 0, reserved = {0, 0, 0, 0}, atime = {sec = 0, 
              nsec = 0}, ctime = {sec = 0, nsec = 0}, mtime = {sec = 0, nsec = 0}, otime = {sec = 0, nsec = 0}}, generation = 8530, root_dirid = 256, bytenr = 1720076648448, byte_limit = 0, bytes_used = 16384, last_snapshot = 8523, 
          flags = 0, refs = 1, drop_progress = {objectid = 0, type = 0 '\000', offset = 0}, drop_level = 0 '\000', level = 0 '\000', generation_v2 = 8530, uuid = '\000' <repeats 15 times>, parent_uuid = '\000' <repeats 15 times>, 
          received_uuid = '\000' <repeats 15 times>, ctransid = 0, otransid = 0, stransid = 0, rtransid = 0, ctime = {sec = 0, nsec = 0}, otime = {sec = 0, nsec = 0}, stime = {sec = 0, nsec = 0}, rtime = {sec = 0, nsec = 0}, reserved = {
            0, 0, 0, 0, 0, 0, 0, 0}}
        dropping_trees = {next = 0x7fffffffe130, prev = 0x7fffffffe130}
        normal_trees = {next = 0x76e3b0, prev = 0x76ebd0}
        root1 = 0x6f5b10
        objectid = 17
        level_size = 16384
        level = 0 '\000'
#8  0x0000000000441b82 in cmd_check (argc=2, argv=0x7fffffffe740) at cmds-check.c:12918
        root_cache = {root = {rb_node = 0x0}}
        root = 0x76ded0
        info = 0x6f5400
        bytenr = 0
        subvolid = 0
        tree_root_bytenr = 0
        chunk_root_bytenr = 0
        uuidbuf = "21e09dd8-a54d-49ec-95cb-93fdd94f0c17"
        ret = 0
        err = 0
        num = 140737488348640
        init_csum_tree = 0
        readonly = 0
        clear_space_cache = 0
        qgroup_report = 0
        qgroups_repaired = 0
        ctree_flags = 64
#9  0x000000000040a734 in main (argc=2, argv=0x7fffffffe740) at btrfs.c:243
        cmd = 0x6ec878
        bname = 0x7fffffffe946 "btrfs"
        ret = 0

--Apple-Mail=_83D61CF0-1B71-45E9-A811-F9F9ACF2FF87--
