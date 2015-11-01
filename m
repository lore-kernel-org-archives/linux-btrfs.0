Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35962 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbKALYz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 06:24:55 -0500
Received: by lbjm5 with SMTP id m5so72051560lbj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 03:24:53 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Nov 2015 06:24:53 -0500
Message-ID: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
Subject: trying to balance, filesystem keeps going read-only.
From: Ken Long <kelargo1000@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a file system of four 5TB drives. Well, one drive is 8TB with a
5TB partition.. the rest are 5TB drives.  I created the initial btrfs
file system on on drive. rsync'd data to it. added another drive.
rsync'd data. added a third drive, rsync'd data. Added a four drive,
trying to balance. The file system gets an error and I have to reboot
to get the file system out of read only.

I dont think it is hardware issue..but It could be...  or it could be
some kind bug in btrfs?
To recover.. I've been comment out the btrfs in fstab, shutdown..
power off.. verify cable connections. Power on. verify all the devices
are present.. remount.

This kind of balance was successful:
btrfs balance start -dusage=55 /mnt/magenta/

but this gets the error below and goes into Read-only:
btrfs filesystem balance /mnt/magenta/

my kernel now is:

Linux ubuntu 4.2.0-17-lowlatency #21-Ubuntu SMP PREEMPT Fri Oct 23
20:40:07 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

~# btrfs filesystem  show
Label: 'uv000'  uuid: f974efbd-82cb-4812-a3b3-eb12ae470f2c
Total devices 4 FS bytes used 11.17TiB
devid    1 size 4.77TiB used 4.26TiB path /dev/sdf1
devid    2 size 4.55TiB used 4.09TiB path /dev/sde
devid    3 size 4.55TiB used 2.74TiB path /dev/sdb
devid    4 size 4.55TiB used 96.03GiB path /dev/sdg

Label: 'LinuxSampler'  uuid: 55aa3bf2-f319-42c7-8f1d-20ee35a91f9a
Total devices 1 FS bytes used 555.80GiB
devid    1 size 2.51TiB used 558.04GiB path /dev/sdf2

# btrfs filesystem df /mnt/btrfs/
Data, single: total=11.16TiB, used=11.16TiB
System, RAID1: total=32.00MiB, used=1.20MiB
Metadata, RAID1: total=10.00GiB, used=8.29GiB
Metadata, DUP: total=4.50GiB, used=4.21GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



# btrfs filesystem usage /mnt/btrfs/
Overall:
    Device size:  18.41TiB
    Device allocated:  11.19TiB
    Device unallocated:   7.22TiB
    Device missing:     0.00B
    Used:  11.18TiB
    Free (estimated):   7.22TiB (min: 3.61TiB)
    Data ratio:      1.00
    Metadata ratio:      2.00
    Global reserve: 512.00MiB (used: 0.00B)

Data,single: Size:11.16TiB, Used:11.16TiB
   /dev/sdb   2.73TiB
   /dev/sde   4.09TiB
   /dev/sdf1   4.25TiB
   /dev/sdg  93.00GiB

Metadata,RAID1: Size:10.00GiB, Used:8.29GiB
   /dev/sdb   5.00GiB
   /dev/sde   6.00GiB
   /dev/sdf1   6.00GiB
   /dev/sdg   3.00GiB

Metadata,DUP: Size:4.50GiB, Used:4.21GiB
   /dev/sdf1   9.00GiB

System,RAID1: Size:32.00MiB, Used:1.20MiB
   /dev/sdb  32.00MiB
   /dev/sdg  32.00MiB

Unallocated:
   /dev/sdb   1.81TiB
   /dev/sde 465.53GiB
   /dev/sdf1 515.80GiB
   /dev/sdg   4.45TiB



and the tail of dmesg -

[50363.836660] ata10: EH complete
[64894.794201] BTRFS info (device sdb): relocating block group
12704106414080 flags 1
[64899.944105] BTRFS info (device sdb): found 124 extents
[64906.622024] BTRFS info (device sdb): found 124 extents
[64906.915197] BTRFS info (device sdb): relocating block group
12703032672256 flags 1
[64915.409311] BTRFS info (device sdb): found 813 extents
[64947.160961] ata10.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[64947.160966] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.160970] ata10.00: cmd 61/c0:00:38:8a:1d/0f:00:0c:00:00/40 tag 0
ncq 2064384 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.160975] ata10.00: status: { DRDY }
[64947.160977] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.160980] ata10.00: cmd 61/80:08:f8:99:1d/0a:00:0c:00:00/40 tag 1
ncq 1376256 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.160981] ata10.00: status: { DRDY }
[64947.160982] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.160985] ata10.00: cmd 61/c0:10:78:a4:1d/0f:00:0c:00:00/40 tag 2
ncq 2064384 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.160987] ata10.00: status: { DRDY }
[64947.160988] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.160991] ata10.00: cmd 61/80:18:38:b4:1d/0a:00:0c:00:00/40 tag 3
ncq 1376256 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.160992] ata10.00: status: { DRDY }
[64947.160994] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.160996] ata10.00: cmd 61/c0:20:b8:be:1d/0f:00:0c:00:00/40 tag 4
ncq 2064384 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.160998] ata10.00: status: { DRDY }
[64947.160999] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161002] ata10.00: cmd 61/40:28:78:ce:1d/1a:00:0c:00:00/40 tag 5
ncq 3440640 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161003] ata10.00: status: { DRDY }
[64947.161005] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161007] ata10.00: cmd 61/40:30:b8:e8:1d/1a:00:0c:00:00/40 tag 6
ncq 3440640 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161009] ata10.00: status: { DRDY }
[64947.161010] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161013] ata10.00: cmd 61/80:38:f8:02:1e/1f:00:0c:00:00/40 tag 7
ncq 4128768 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161014] ata10.00: status: { DRDY }
[64947.161015] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161018] ata10.00: cmd 61/00:40:78:22:1e/15:00:0c:00:00/40 tag 8
ncq 2752512 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161020] ata10.00: status: { DRDY }
[64947.161021] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161024] ata10.00: cmd 61/c0:48:78:37:1e/0f:00:0c:00:00/40 tag 9
ncq 2064384 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161025] ata10.00: status: { DRDY }
[64947.161026] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161029] ata10.00: cmd 61/c0:50:38:47:1e/0f:00:0c:00:00/40 tag
10 ncq 2064384 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161031] ata10.00: status: { DRDY }
[64947.161032] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161035] ata10.00: cmd 61/c0:58:f8:56:1e/0f:00:0c:00:00/40 tag
11 ncq 2064384 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161036] ata10.00: status: { DRDY }
[64947.161037] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161040] ata10.00: cmd 61/80:60:48:34:1a/34:00:0c:00:00/40 tag
12 ncq 6881280 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161041] ata10.00: status: { DRDY }
[64947.161043] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161045] ata10.00: cmd 61/00:68:c8:68:1a/15:00:0c:00:00/40 tag
13 ncq 2752512 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161047] ata10.00: status: { DRDY }
[64947.161048] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161051] ata10.00: cmd 61/c0:70:c8:7d:1a/0f:00:0c:00:00/40 tag
14 ncq 2064384 out
                        res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161052] ata10.00: status: { DRDY }
[64947.161054] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161056] ata10.00: cmd 61/00:78:88:8d:1a/2a:00:0c:00:00/40 tag
15 ncq 5505024 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161058] ata10.00: status: { DRDY }
[64947.161059] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161062] ata10.00: cmd 61/00:80:88:b7:1a/3f:00:0c:00:00/40 tag
16 ncq 8257536 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161063] ata10.00: status: { DRDY }
[64947.161064] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161067] ata10.00: cmd 61/00:88:88:f6:1a/3f:00:0c:00:00/40 tag
17 ncq 8257536 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161069] ata10.00: status: { DRDY }
[64947.161070] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161073] ata10.00: cmd 61/b0:90:88:35:1b/47:00:0c:00:00/40 tag
18 ncq 9396224 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161074] ata10.00: status: { DRDY }
[64947.161075] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161078] ata10.00: cmd 61/80:98:38:7d:1b/49:00:0c:00:00/40 tag
19 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161079] ata10.00: status: { DRDY }
[64947.161081] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161083] ata10.00: cmd 61/80:a0:b8:c6:1b/49:00:0c:00:00/40 tag
20 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161085] ata10.00: status: { DRDY }
[64947.161086] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161089] ata10.00: cmd 61/80:a8:38:10:1c/34:00:0c:00:00/40 tag
21 ncq 6881280 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161090] ata10.00: status: { DRDY }
[64947.161091] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161094] ata10.00: cmd 61/40:b0:b8:44:1c/2f:00:0c:00:00/40 tag
22 ncq 6193152 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161096] ata10.00: status: { DRDY }
[64947.161097] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161099] ata10.00: cmd 61/80:b8:f8:73:1c/34:00:0c:00:00/40 tag
23 ncq 6881280 out
                        res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161101] ata10.00: status: { DRDY }
[64947.161102] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161105] ata10.00: cmd 61/00:c0:78:a8:1c/2a:00:0c:00:00/40 tag
24 ncq 5505024 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161106] ata10.00: status: { DRDY }
[64947.161108] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161110] ata10.00: cmd 61/80:c8:78:d2:1c/34:00:0c:00:00/40 tag
25 ncq 6881280 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161112] ata10.00: status: { DRDY }
[64947.161113] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161116] ata10.00: cmd 61/00:d0:f8:06:1d/2a:00:0c:00:00/40 tag
26 ncq 5505024 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161117] ata10.00: status: { DRDY }
[64947.161118] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161121] ata10.00: cmd 61/80:d8:f8:30:1d/1f:00:0c:00:00/40 tag
27 ncq 4128768 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161123] ata10.00: status: { DRDY }
[64947.161124] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161126] ata10.00: cmd 61/00:e0:78:50:1d/15:00:0c:00:00/40 tag
28 ncq 2752512 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161128] ata10.00: status: { DRDY }
[64947.161129] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161132] ata10.00: cmd 61/00:e8:78:65:1d/15:00:0c:00:00/40 tag
29 ncq 2752512 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[64947.161133] ata10.00: status: { DRDY }
[64947.161135] ata10.00: failed command: WRITE FPDMA QUEUED
[64947.161137] ata10.00: cmd 61/c0:f0:78:7a:1d/0f:00:0c:00:00/40 tag
30 ncq 2064384 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[64947.161139] ata10.00: status: { DRDY }
[64947.161141] ata10: hard resetting link
[64948.489867] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[64949.160880] ata10.00: configured for UDMA/133
[64949.160887] ata10.00: device reported invalid CHS sector 0
[64949.160890] ata10.00: device reported invalid CHS sector 0
[64949.160893] ata10.00: device reported invalid CHS sector 0
[64949.160895] ata10.00: device reported invalid CHS sector 0
[64949.160897] ata10.00: device reported invalid CHS sector 0
[64949.160899] ata10.00: device reported invalid CHS sector 0
[64949.160901] ata10.00: device reported invalid CHS sector 0
[64949.160903] ata10.00: device reported invalid CHS sector 0
[64949.160905] ata10.00: device reported invalid CHS sector 0
[64949.160907] ata10.00: device reported invalid CHS sector 0
[64949.160910] ata10.00: device reported invalid CHS sector 0
[64949.160912] ata10.00: device reported invalid CHS sector 0
[64949.160914] ata10.00: device reported invalid CHS sector 0
[64949.160918] ata10.00: device reported invalid CHS sector 0
[64949.160923] ata10.00: device reported invalid CHS sector 0
[64949.160925] ata10.00: device reported invalid CHS sector 0
[64949.160928] ata10.00: device reported invalid CHS sector 0
[64949.160930] ata10.00: device reported invalid CHS sector 0
[64949.160932] ata10.00: device reported invalid CHS sector 0
[64949.160935] ata10.00: device reported invalid CHS sector 0
[64949.160938] ata10.00: device reported invalid CHS sector 0
[64949.160939] ata10.00: device reported invalid CHS sector 0
[64949.160941] ata10.00: device reported invalid CHS sector 0
[64949.160944] ata10.00: device reported invalid CHS sector 0
[64949.160946] ata10.00: device reported invalid CHS sector 0
[64949.160947] ata10.00: device reported invalid CHS sector 0
[64949.160996] ata10: EH complete
[64955.864632] BTRFS info (device sdb): found 813 extents
[64956.134325] BTRFS info (device sdb): relocating block group
12701958930432 flags 1
[64968.178161] BTRFS info (device sdb): found 515 extents
[64983.381965] BTRFS info (device sdb): found 514 extents
[64990.817396] BTRFS info (device sdb): relocating block group
12700885188608 flags 1
[65001.862965] BTRFS info (device sdb): found 589 extents
[65013.582353] BTRFS info (device sdb): found 589 extents
[65013.842346] BTRFS info (device sdb): relocating block group
12699811446784 flags 1
[65024.333072] BTRFS info (device sdb): found 590 extents
[65039.328317] BTRFS info (device sdb): found 589 extents
[65041.844447] BTRFS info (device sdb): relocating block group
12698737704960 flags 1
[65053.542831] BTRFS info (device sdb): found 605 extents
[65062.586780] BTRFS info (device sdb): found 605 extents
[65062.802442] BTRFS info (device sdb): relocating block group
12697663963136 flags 1
[65072.632867] BTRFS info (device sdb): found 594 extents
[65087.098949] BTRFS info (device sdb): found 593 extents
[65095.059930] BTRFS info (device sdb): relocating block group
12696590221312 flags 1
[65108.412870] BTRFS info (device sdb): found 594 extents
[65121.653399] BTRFS info (device sdb): found 594 extents
[65128.143378] BTRFS info (device sdb): relocating block group
12695516479488 flags 1
[65141.366300] BTRFS info (device sdb): found 559 extents
[65153.866263] BTRFS info (device sdb): found 559 extents
[65154.184637] BTRFS info (device sdb): relocating block group
12694442737664 flags 1
[65164.484497] BTRFS info (device sdb): found 461 extents
[65179.477402] BTRFS info (device sdb): found 460 extents
[65180.017991] BTRFS info (device sdb): relocating block group
12693368995840 flags 1
[65193.090343] BTRFS info (device sdb): found 708 extents
[65204.944439] BTRFS info (device sdb): found 708 extents
[65205.195811] BTRFS info (device sdb): relocating block group
12692295254016 flags 1
[65218.108321] BTRFS info (device sdb): found 863 extents
[65232.170032] BTRFS info (device sdb): found 863 extents
[65233.119839] BTRFS info (device sdb): relocating block group
12691221512192 flags 1
[65244.551964] BTRFS info (device sdb): found 1115 extents
[65256.630341] BTRFS info (device sdb): found 1115 extents
[65269.714070] BTRFS info (device sdb): relocating block group
12690147770368 flags 1
[65287.041036] BTRFS info (device sdb): found 1050 extents
[65321.599325] ata10.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[65321.599335] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599345] ata10.00: cmd 61/c0:00:e0:17:68/24:00:0a:00:00/40 tag 0
ncq 4816896 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599351] ata10.00: status: { DRDY }
[65321.599355] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599363] ata10.00: cmd 61/c0:08:a0:3c:68/24:00:0a:00:00/40 tag 1
ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599367] ata10.00: status: { DRDY }
[65321.599371] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599378] ata10.00: cmd 61/c0:10:60:61:68/24:00:0a:00:00/40 tag 2
ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599382] ata10.00: status: { DRDY }
[65321.599385] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599393] ata10.00: cmd 61/c0:18:20:86:68/24:00:0a:00:00/40 tag 3
ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599397] ata10.00: status: { DRDY }
[65321.599400] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599408] ata10.00: cmd 61/c0:20:e0:aa:68/24:00:0a:00:00/40 tag 4
ncq 4816896 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599415] ata10.00: status: { DRDY }
[65321.599422] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599430] ata10.00: cmd 61/c0:28:a0:cf:68/24:00:0a:00:00/40 tag 5
ncq 4816896 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599434] ata10.00: status: { DRDY }
[65321.599437] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599444] ata10.00: cmd 61/c0:30:60:f4:68/24:00:0a:00:00/40 tag 6
ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599453] ata10.00: status: { DRDY }
[65321.599455] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599457] ata10.00: cmd 61/c0:38:20:19:69/24:00:0a:00:00/40 tag 7
ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599459] ata10.00: status: { DRDY }
[65321.599460] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599463] ata10.00: cmd 61/c0:40:e0:3d:69/39:00:0a:00:00/40 tag 8
ncq 7569408 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599464] ata10.00: status: { DRDY }
[65321.599466] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599468] ata10.00: cmd 61/00:48:a0:77:69/3f:00:0a:00:00/40 tag 9
ncq 8257536 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599470] ata10.00: status: { DRDY }
[65321.599471] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599474] ata10.00: cmd 61/00:50:a0:b6:69/3f:00:0a:00:00/40 tag
10 ncq 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599475] ata10.00: status: { DRDY }
[65321.599476] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599479] ata10.00: cmd 61/00:58:a0:f5:69/3f:00:0a:00:00/40 tag
11 ncq 8257536 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599481] ata10.00: status: { DRDY }
[65321.599482] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599485] ata10.00: cmd 61/80:60:a0:34:6a/34:00:0a:00:00/40 tag
12 ncq 6881280 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599486] ata10.00: status: { DRDY }
[65321.599487] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599490] ata10.00: cmd 61/00:68:20:69:6a/3f:00:0a:00:00/40 tag
13 ncq 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599491] ata10.00: status: { DRDY }
[65321.599493] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599495] ata10.00: cmd 61/40:70:20:a8:6a/2f:00:0a:00:00/40 tag
14 ncq 6193152 out
                        res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599497] ata10.00: status: { DRDY }
[65321.599498] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599501] ata10.00: cmd 61/00:78:60:d7:6a/3f:00:0a:00:00/40 tag
15 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599502] ata10.00: status: { DRDY }
[65321.599503] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599506] ata10.00: cmd 61/00:80:60:16:6b/3f:00:0a:00:00/40 tag
16 ncq 8257536 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599508] ata10.00: status: { DRDY }
[65321.599509] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599511] ata10.00: cmd 61/00:88:60:55:6b/3f:00:0a:00:00/40 tag
17 ncq 8257536 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599513] ata10.00: status: { DRDY }
[65321.599514] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599517] ata10.00: cmd 61/00:90:60:94:6b/3f:00:0a:00:00/40 tag
18 ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599518] ata10.00: status: { DRDY }
[65321.599520] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599522] ata10.00: cmd 61/00:98:60:d3:6b/3f:00:0a:00:00/40 tag
19 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599524] ata10.00: status: { DRDY }
[65321.599525] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599528] ata10.00: cmd 61/00:a0:60:12:6c/3f:00:0a:00:00/40 tag
20 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599529] ata10.00: status: { DRDY }
[65321.599530] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599533] ata10.00: cmd 61/80:a8:60:51:6c/49:00:0a:00:00/40 tag
21 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599535] ata10.00: status: { DRDY }
[65321.599536] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599538] ata10.00: cmd 61/80:b0:e0:9a:6c/49:00:0a:00:00/40 tag
22 ncq 9633792 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599540] ata10.00: status: { DRDY }
[65321.599541] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599544] ata10.00: cmd 61/80:b8:60:e4:6c/49:00:0a:00:00/40 tag
23 ncq 9633792 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599545] ata10.00: status: { DRDY }
[65321.599547] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599549] ata10.00: cmd 61/80:c0:e0:2d:6d/49:00:0a:00:00/40 tag
24 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599551] ata10.00: status: { DRDY }
[65321.599552] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599555] ata10.00: cmd 61/80:c8:60:77:6d/49:00:0a:00:00/40 tag
25 ncq 9633792 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599556] ata10.00: status: { DRDY }
[65321.599557] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599560] ata10.00: cmd 61/80:d0:e0:c0:6d/49:00:0a:00:00/40 tag
26 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599561] ata10.00: status: { DRDY }
[65321.599563] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599565] ata10.00: cmd 61/80:d8:60:0a:6e/49:00:0a:00:00/40 tag
27 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599567] ata10.00: status: { DRDY }
[65321.599568] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599571] ata10.00: cmd 61/80:e0:e0:53:6e/49:00:0a:00:00/40 tag
28 ncq 9633792 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599572] ata10.00: status: { DRDY }
[65321.599574] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599576] ata10.00: cmd 61/40:e8:60:9d:6e/2f:00:0a:00:00/40 tag
29 ncq 6193152 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65321.599578] ata10.00: status: { DRDY }
[65321.599579] ata10.00: failed command: WRITE FPDMA QUEUED
[65321.599582] ata10.00: cmd 61/00:f0:a0:cc:6e/15:00:0a:00:00/40 tag
30 ncq 2752512 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65321.599583] ata10.00: status: { DRDY }
[65321.599586] ata10: hard resetting link
[65322.059949] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65322.062013] ata10.00: configured for UDMA/133
[65322.062019] ata10.00: device reported invalid CHS sector 0
[65322.062022] ata10.00: device reported invalid CHS sector 0
[65322.062025] ata10.00: device reported invalid CHS sector 0
[65322.062027] ata10.00: device reported invalid CHS sector 0
[65322.062029] ata10.00: device reported invalid CHS sector 0
[65322.062031] ata10.00: device reported invalid CHS sector 0
[65322.062033] ata10.00: device reported invalid CHS sector 0
[65322.062036] ata10.00: device reported invalid CHS sector 0
[65322.062038] ata10.00: device reported invalid CHS sector 0
[65322.062041] ata10.00: device reported invalid CHS sector 0
[65322.062043] ata10.00: device reported invalid CHS sector 0
[65322.062045] ata10.00: device reported invalid CHS sector 0
[65322.062048] ata10.00: device reported invalid CHS sector 0
[65322.062050] ata10.00: device reported invalid CHS sector 0
[65322.062053] ata10.00: device reported invalid CHS sector 0
[65322.062059] ata10.00: device reported invalid CHS sector 0
[65322.062061] ata10.00: device reported invalid CHS sector 0
[65322.062063] ata10.00: device reported invalid CHS sector 0
[65322.062066] ata10.00: device reported invalid CHS sector 0
[65322.062068] ata10.00: device reported invalid CHS sector 0
[65322.062070] ata10.00: device reported invalid CHS sector 0
[65322.062072] ata10.00: device reported invalid CHS sector 0
[65322.062074] ata10.00: device reported invalid CHS sector 0
[65322.062076] ata10.00: device reported invalid CHS sector 0
[65322.062078] ata10.00: device reported invalid CHS sector 0
[65322.062081] ata10.00: device reported invalid CHS sector 0
[65322.062083] ata10.00: device reported invalid CHS sector 0
[65322.062085] ata10.00: device reported invalid CHS sector 0
[65322.062145] ata10: EH complete
[65337.185266] BTRFS info (device sdb): found 1050 extents
[65348.026023] BTRFS info (device sdb): relocating block group
12689074028544 flags 1
[65364.906479] BTRFS info (device sdb): found 1196 extents
[65399.708610] ata10.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[65399.708615] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708619] ata10.00: cmd 61/c0:00:f0:58:47/24:00:0a:00:00/40 tag 0
ncq 4816896 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708621] ata10.00: status: { DRDY }
[65399.708623] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708626] ata10.00: cmd 61/40:08:b0:7d:47/2f:00:0a:00:00/40 tag 1
ncq 6193152 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708627] ata10.00: status: { DRDY }
[65399.708629] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708631] ata10.00: cmd 61/00:10:f0:ac:47/3f:00:0a:00:00/40 tag 2
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708633] ata10.00: status: { DRDY }
[65399.708634] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708637] ata10.00: cmd 61/00:18:f0:eb:47/3f:00:0a:00:00/40 tag 3
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708639] ata10.00: status: { DRDY }
[65399.708640] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708642] ata10.00: cmd 61/80:20:f0:2a:48/34:00:0a:00:00/40 tag 4
ncq 6881280 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708644] ata10.00: status: { DRDY }
[65399.708645] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708648] ata10.00: cmd 61/00:28:70:5f:48/3f:00:0a:00:00/40 tag 5
ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708649] ata10.00: status: { DRDY }
[65399.708651] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708653] ata10.00: cmd 61/00:30:70:9e:48/3f:00:0a:00:00/40 tag 6
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708655] ata10.00: status: { DRDY }
[65399.708656] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708659] ata10.00: cmd 61/00:38:70:dd:48/3f:00:0a:00:00/40 tag 7
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708660] ata10.00: status: { DRDY }
[65399.708661] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708664] ata10.00: cmd 61/00:40:70:1c:49/3f:00:0a:00:00/40 tag 8
ncq 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708666] ata10.00: status: { DRDY }
[65399.708667] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708670] ata10.00: cmd 61/80:48:70:5b:49/34:00:0a:00:00/40 tag 9
ncq 6881280 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708671] ata10.00: status: { DRDY }
[65399.708672] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708675] ata10.00: cmd 61/b0:50:f0:8f:49/3e:00:0a:00:00/40 tag
10 ncq 8216576 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708676] ata10.00: status: { DRDY }
[65399.708678] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708680] ata10.00: cmd 61/00:58:a0:ce:49/3f:00:0a:00:00/40 tag
11 ncq 8257536 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708682] ata10.00: status: { DRDY }
[65399.708683] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708686] ata10.00: cmd 61/00:60:a0:0d:4a/3f:00:0a:00:00/40 tag
12 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708687] ata10.00: status: { DRDY }
[65399.708689] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708691] ata10.00: cmd 61/00:68:a0:4c:4a/3f:00:0a:00:00/40 tag
13 ncq 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708693] ata10.00: status: { DRDY }
[65399.708694] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708697] ata10.00: cmd 61/00:70:a0:8b:4a/3f:00:0a:00:00/40 tag
14 ncq 8257536 out
                        res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708698] ata10.00: status: { DRDY }
[65399.708700] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708702] ata10.00: cmd 61/00:78:a0:ca:4a/3f:00:0a:00:00/40 tag
15 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708704] ata10.00: status: { DRDY }
[65399.708705] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708708] ata10.00: cmd 61/40:80:a0:09:4b/44:00:0a:00:00/40 tag
16 ncq 8945664 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708709] ata10.00: status: { DRDY }
[65399.708711] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708713] ata10.00: cmd 61/80:88:e0:4d:4b/49:00:0a:00:00/40 tag
17 ncq 9633792 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708715] ata10.00: status: { DRDY }
[65399.708716] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708719] ata10.00: cmd 61/80:90:60:97:4b/49:00:0a:00:00/40 tag
18 ncq 9633792 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708720] ata10.00: status: { DRDY }
[65399.708721] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708724] ata10.00: cmd 61/80:98:e0:e0:4b/49:00:0a:00:00/40 tag
19 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708726] ata10.00: status: { DRDY }
[65399.708727] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708729] ata10.00: cmd 61/80:a0:60:2a:4c/49:00:0a:00:00/40 tag
20 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708731] ata10.00: status: { DRDY }
[65399.708732] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708735] ata10.00: cmd 61/80:a8:e0:73:4c/49:00:0a:00:00/40 tag
21 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708736] ata10.00: status: { DRDY }
[65399.708738] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708740] ata10.00: cmd 61/40:b0:60:bd:4c/44:00:0a:00:00/40 tag
22 ncq 8945664 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708742] ata10.00: status: { DRDY }
[65399.708743] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708746] ata10.00: cmd 61/00:b8:a0:01:4d/2a:00:0a:00:00/40 tag
23 ncq 5505024 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708747] ata10.00: status: { DRDY }
[65399.708748] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708751] ata10.00: cmd 61/58:c0:18:55:46/27:00:0a:00:00/40 tag
24 ncq 5156864 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708753] ata10.00: status: { DRDY }
[65399.708754] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708757] ata10.00: cmd 61/c0:c8:70:7c:46/24:00:0a:00:00/40 tag
25 ncq 4816896 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708758] ata10.00: status: { DRDY }
[65399.708759] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708762] ata10.00: cmd 61/c0:d0:30:a1:46/24:00:0a:00:00/40 tag
26 ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708763] ata10.00: status: { DRDY }
[65399.708765] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708767] ata10.00: cmd 61/c0:d8:f0:c5:46/24:00:0a:00:00/40 tag
27 ncq 4816896 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708769] ata10.00: status: { DRDY }
[65399.708770] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708773] ata10.00: cmd 61/c0:e0:b0:ea:46/24:00:0a:00:00/40 tag
28 ncq 4816896 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708774] ata10.00: status: { DRDY }
[65399.708775] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708778] ata10.00: cmd 61/c0:e8:70:0f:47/24:00:0a:00:00/40 tag
29 ncq 4816896 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65399.708780] ata10.00: status: { DRDY }
[65399.708781] ata10.00: failed command: WRITE FPDMA QUEUED
[65399.708784] ata10.00: cmd 61/c0:f0:30:34:47/24:00:0a:00:00/40 tag
30 ncq 4816896 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65399.708785] ata10.00: status: { DRDY }
[65399.708788] ata10: hard resetting link
[65400.475738] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65400.477843] ata10.00: configured for UDMA/133
[65400.477849] ata10.00: device reported invalid CHS sector 0
[65400.477852] ata10.00: device reported invalid CHS sector 0
[65400.477855] ata10.00: device reported invalid CHS sector 0
[65400.477857] ata10.00: device reported invalid CHS sector 0
[65400.477860] ata10.00: device reported invalid CHS sector 0
[65400.477862] ata10.00: device reported invalid CHS sector 0
[65400.477864] ata10.00: device reported invalid CHS sector 0
[65400.477866] ata10.00: device reported invalid CHS sector 0
[65400.477868] ata10.00: device reported invalid CHS sector 0
[65400.477870] ata10.00: device reported invalid CHS sector 0
[65400.477873] ata10.00: device reported invalid CHS sector 0
[65400.477875] ata10.00: device reported invalid CHS sector 0
[65400.477877] ata10.00: device reported invalid CHS sector 0
[65400.477879] ata10.00: device reported invalid CHS sector 0
[65400.477883] ata10.00: device reported invalid CHS sector 0
[65400.477887] ata10.00: device reported invalid CHS sector 0
[65400.477889] ata10.00: device reported invalid CHS sector 0
[65400.477894] ata10.00: device reported invalid CHS sector 0
[65400.477896] ata10.00: device reported invalid CHS sector 0
[65400.477898] ata10.00: device reported invalid CHS sector 0
[65400.477900] ata10.00: device reported invalid CHS sector 0
[65400.477902] ata10.00: device reported invalid CHS sector 0
[65400.477911] ata10.00: device reported invalid CHS sector 0
[65400.477913] ata10.00: device reported invalid CHS sector 0
[65400.477915] ata10.00: device reported invalid CHS sector 0
[65400.477917] ata10.00: device reported invalid CHS sector 0
[65400.477919] ata10.00: device reported invalid CHS sector 0
[65400.477921] ata10.00: device reported invalid CHS sector 0
[65400.477968] ata10: EH complete
[65416.120225] BTRFS info (device sdb): found 1196 extents
[65426.021800] BTRFS info (device sdb): relocating block group
12688000286720 flags 1
[65442.648467] BTRFS info (device sdb): found 1159 extents
[65477.821989] ata10.00: NCQ disabled due to excessive errors
[65477.821993] ata10.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0
action 0x6 frozen
[65477.821997] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822000] ata10.00: cmd 61/80:00:80:cd:2b/49:00:0a:00:00/40 tag 0
ncq 9633792 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822002] ata10.00: status: { DRDY }
[65477.822003] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822006] ata10.00: cmd 61/80:08:00:17:2c/49:00:0a:00:00/40 tag 1
ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822008] ata10.00: status: { DRDY }
[65477.822009] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822011] ata10.00: cmd 61/80:10:80:60:2c/49:00:0a:00:00/40 tag 2
ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822013] ata10.00: status: { DRDY }
[65477.822014] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822016] ata10.00: cmd 61/00:18:00:aa:2c/3f:00:0a:00:00/40 tag 3
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822018] ata10.00: status: { DRDY }
[65477.822019] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822021] ata10.00: cmd 61/c0:20:00:e9:2c/24:00:0a:00:00/40 tag 4
ncq 4816896 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822023] ata10.00: status: { DRDY }
[65477.822024] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822026] ata10.00: cmd 61/80:28:c0:0d:2d/49:00:0a:00:00/40 tag 5
ncq 9633792 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822028] ata10.00: status: { DRDY }
[65477.822029] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822031] ata10.00: cmd 61/00:30:40:57:2d/3f:00:0a:00:00/40 tag 6
ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822033] ata10.00: status: { DRDY }
[65477.822034] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822036] ata10.00: cmd 61/00:38:40:96:2d/2a:00:0a:00:00/40 tag 7
ncq 5505024 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822038] ata10.00: status: { DRDY }
[65477.822039] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822041] ata10.00: cmd 61/00:40:40:c0:2d/15:00:0a:00:00/40 tag 8
ncq 2752512 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822043] ata10.00: status: { DRDY }
[65477.822044] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822046] ata10.00: cmd 61/00:48:40:d5:2d/15:00:0a:00:00/40 tag 9
ncq 2752512 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822048] ata10.00: status: { DRDY }
[65477.822049] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822051] ata10.00: cmd 61/00:50:40:ea:2d/15:00:0a:00:00/40 tag
10 ncq 2752512 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822053] ata10.00: status: { DRDY }
[65477.822054] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822056] ata10.00: cmd 61/c0:58:40:ff:2d/0f:00:0a:00:00/40 tag
11 ncq 2064384 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822058] ata10.00: status: { DRDY }
[65477.822059] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822061] ata10.00: cmd 61/40:60:c0:64:27/2f:00:0a:00:00/40 tag
12 ncq 6193152 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822063] ata10.00: status: { DRDY }
[65477.822064] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822066] ata10.00: cmd 61/00:68:00:94:27/3f:00:0a:00:00/40 tag
13 ncq 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822068] ata10.00: status: { DRDY }
[65477.822069] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822071] ata10.00: cmd 61/00:70:00:d3:27/3f:00:0a:00:00/40 tag
14 ncq 8257536 out
                        res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822073] ata10.00: status: { DRDY }
[65477.822074] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822076] ata10.00: cmd 61/00:78:00:12:28/3f:00:0a:00:00/40 tag
15 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822078] ata10.00: status: { DRDY }
[65477.822079] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822081] ata10.00: cmd 61/00:80:00:51:28/2a:00:0a:00:00/40 tag
16 ncq 5505024 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822083] ata10.00: status: { DRDY }
[65477.822084] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822086] ata10.00: cmd 61/c0:88:00:7b:28/0f:00:0a:00:00/40 tag
17 ncq 2064384 out
                        res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822088] ata10.00: status: { DRDY }
[65477.822089] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822091] ata10.00: cmd 61/80:90:c0:8a:28/34:00:0a:00:00/40 tag
18 ncq 6881280 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822093] ata10.00: status: { DRDY }
[65477.822094] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822096] ata10.00: cmd 61/00:98:40:bf:28/3f:00:0a:00:00/40 tag
19 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822098] ata10.00: status: { DRDY }
[65477.822099] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822101] ata10.00: cmd 61/00:a0:40:fe:28/3f:00:0a:00:00/40 tag
20 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822103] ata10.00: status: { DRDY }
[65477.822104] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822106] ata10.00: cmd 61/00:a8:40:3d:29/3f:00:0a:00:00/40 tag
21 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822108] ata10.00: status: { DRDY }
[65477.822109] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822111] ata10.00: cmd 61/00:b0:40:7c:29/3f:00:0a:00:00/40 tag
22 ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822113] ata10.00: status: { DRDY }
[65477.822114] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822116] ata10.00: cmd 61/00:b8:40:bb:29/3f:00:0a:00:00/40 tag
23 ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822118] ata10.00: status: { DRDY }
[65477.822119] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822121] ata10.00: cmd 61/00:c0:40:fa:29/3f:00:0a:00:00/40 tag
24 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822123] ata10.00: status: { DRDY }
[65477.822124] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822126] ata10.00: cmd 61/00:c8:40:39:2a/3f:00:0a:00:00/40 tag
25 ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822128] ata10.00: status: { DRDY }
[65477.822129] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822131] ata10.00: cmd 61/00:d0:40:78:2a/3f:00:0a:00:00/40 tag
26 ncq 8257536 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822133] ata10.00: status: { DRDY }
[65477.822134] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822136] ata10.00: cmd 61/80:d8:40:b7:2a/49:00:0a:00:00/40 tag
27 ncq 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822138] ata10.00: status: { DRDY }
[65477.822139] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822141] ata10.00: cmd 61/40:e0:c0:00:2b/44:00:0a:00:00/40 tag
28 ncq 8945664 out
                        res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822143] ata10.00: status: { DRDY }
[65477.822144] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822146] ata10.00: cmd 61/00:e8:00:45:2b/3f:00:0a:00:00/40 tag
29 ncq 8257536 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65477.822148] ata10.00: status: { DRDY }
[65477.822149] ata10.00: failed command: WRITE FPDMA QUEUED
[65477.822151] ata10.00: cmd 61/80:f0:00:84:2b/49:00:0a:00:00/40 tag
30 ncq 9633792 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65477.822153] ata10.00: status: { DRDY }
[65477.822155] ata10: hard resetting link
[65478.384707] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65478.386754] ata10.00: configured for UDMA/133
[65478.386760] ata10.00: device reported invalid CHS sector 0
[65478.386763] ata10.00: device reported invalid CHS sector 0
[65478.386765] ata10.00: device reported invalid CHS sector 0
[65478.386768] ata10.00: device reported invalid CHS sector 0
[65478.386770] ata10.00: device reported invalid CHS sector 0
[65478.386773] ata10.00: device reported invalid CHS sector 0
[65478.386776] ata10.00: device reported invalid CHS sector 0
[65478.386778] ata10.00: device reported invalid CHS sector 0
[65478.386780] ata10.00: device reported invalid CHS sector 0
[65478.386782] ata10.00: device reported invalid CHS sector 0
[65478.386784] ata10.00: device reported invalid CHS sector 0
[65478.386786] ata10.00: device reported invalid CHS sector 0
[65478.386789] ata10.00: device reported invalid CHS sector 0
[65478.386791] ata10.00: device reported invalid CHS sector 0
[65478.386794] ata10.00: device reported invalid CHS sector 0
[65478.386799] ata10.00: device reported invalid CHS sector 0
[65478.386801] ata10.00: device reported invalid CHS sector 0
[65478.386803] ata10.00: device reported invalid CHS sector 0
[65478.386805] ata10.00: device reported invalid CHS sector 0
[65478.386808] ata10.00: device reported invalid CHS sector 0
[65478.386810] ata10.00: device reported invalid CHS sector 0
[65478.386812] ata10.00: device reported invalid CHS sector 0
[65478.386814] ata10.00: device reported invalid CHS sector 0
[65478.386817] ata10.00: device reported invalid CHS sector 0
[65478.386819] ata10.00: device reported invalid CHS sector 0
[65478.386821] ata10.00: device reported invalid CHS sector 0
[65478.386823] ata10.00: device reported invalid CHS sector 0
[65478.386825] ata10.00: device reported invalid CHS sector 0
[65478.386876] ata10: EH complete
[65491.016892] BTRFS info (device sdb): found 1159 extents
[65498.182759] BTRFS info (device sdb): relocating block group
12686926544896 flags 1
[65514.274722] BTRFS info (device sdb): found 1136 extents
[65549.988971] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[65549.988976] ata10.00: failed command: WRITE DMA EXT
[65549.988980] ata10.00: cmd 35/00:80:60:1f:07/00:34:0a:00:00/e0 tag
10 dma 6881280 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65549.988983] ata10.00: status: { DRDY }
[65549.988986] ata10: hard resetting link
[65550.657010] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65550.659086] ata10.00: configured for UDMA/133
[65550.659093] ata10.00: device reported invalid CHS sector 0
[65550.659104] ata10: EH complete
[65561.736308] BTRFS info (device sdb): found 1136 extents
[65568.511648] BTRFS info (device sdb): relocating block group
12685852803072 flags 1
[65582.277838] BTRFS info (device sdb): found 1093 extents
[65617.026925] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[65617.026930] ata10.00: failed command: WRITE DMA EXT
[65617.026934] ata10.00: cmd 35/00:c0:f0:72:e7/00:39:09:00:00/e0 tag
23 dma 7569408 out
                        res 40/00:01:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[65617.026936] ata10.00: status: { DRDY }
[65617.026939] ata10: hard resetting link
[65617.691817] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65617.693789] ata10.00: configured for UDMA/133
[65617.693795] ata10.00: device reported invalid CHS sector 0
[65617.693805] ata10: EH complete
[65627.964373] BTRFS info (device sdb): found 1093 extents
[65633.917247] BTRFS info (device sdb): relocating block group
12684779061248 flags 1
[65645.904070] BTRFS info (device sdb): found 677 extents
[65681.116607] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[65681.116612] ata10.00: failed command: WRITE DMA EXT
[65681.116616] ata10.00: cmd 35/00:00:00:05:c6/00:3f:09:00:00/e0 tag 8
dma 8257536 out
                        res 40/00:ff:00:00:00/00:00:00:00:00/40 Emask
0x4 (timeout)
[65681.116617] ata10.00: status: { DRDY }
[65681.116620] ata10: hard resetting link
[65681.577198] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[65681.579145] ata10.00: configured for UDMA/133
[65681.579150] ata10.00: device reported invalid CHS sector 0
[65681.579180] ata10: EH complete
[65691.185648] BTRFS info (device sdb): found 677 extents
[65697.403911] BTRFS info (device sdb): relocating block group
12683705319424 flags 1
[65709.856245] BTRFS info (device sdb): found 894 extents
[65744.245002] ata10: limiting SATA link speed to 3.0 Gbps
[65744.245006] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[65744.245010] ata10.00: failed command: WRITE DMA EXT
[65744.245014] ata10.00: cmd 35/00:80:80:bf:a4/00:49:09:00:00/e0 tag
13 dma 9633792 out
                        res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[65744.245016] ata10.00: status: { DRDY }
[65744.245019] ata10: hard resetting link
[65754.260004] ata10: softreset failed (1st FIS failed)
[65754.260009] ata10: hard resetting link
[65764.275019] ata10: softreset failed (1st FIS failed)
[65764.275024] ata10: hard resetting link
[65799.324093] ata10: softreset failed (1st FIS failed)
[65799.324099] ata10: limiting SATA link speed to 1.5 Gbps
[65799.324101] ata10: hard resetting link
[65804.485377] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65804.485382] ata10.00: link online but device misclassified
[65809.492329] ata10.00: qc timeout (cmd 0xec)
[65809.492337] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[65809.492339] ata10.00: revalidation failed (errno=-5)
[65809.492343] ata10: hard resetting link
[65819.506370] ata10: softreset failed (1st FIS failed)
[65819.506375] ata10: hard resetting link
[65829.520372] ata10: softreset failed (1st FIS failed)
[65829.520377] ata10: hard resetting link
[65864.570515] ata10: softreset failed (1st FIS failed)
[65864.570521] ata10: hard resetting link
[65869.778809] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65869.778818] ata10.00: link online but device misclassified
[65879.792761] ata10.00: qc timeout (cmd 0xec)
[65879.792769] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[65879.792770] ata10.00: revalidation failed (errno=-5)
[65879.792775] ata10: hard resetting link
[65889.807846] ata10: softreset failed (1st FIS failed)
[65889.807856] ata10: hard resetting link
[65899.821866] ata10: softreset failed (1st FIS failed)
[65899.821875] ata10: hard resetting link
[65934.870889] ata10: softreset failed (1st FIS failed)
[65934.870900] ata10: hard resetting link
[65940.079247] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[65940.079252] ata10.00: link online but device misclassified
[65970.121295] ata10.00: qc timeout (cmd 0xec)
[65970.121308] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[65970.121312] ata10.00: revalidation failed (errno=-5)
[65970.121317] ata10.00: disabled
[65970.121331] ata10.00: device reported invalid CHS sector 0
[65970.121343] ata10: hard resetting link
[65980.136313] ata10: softreset failed (1st FIS failed)
[65980.136323] ata10: hard resetting link
[65990.150333] ata10: softreset failed (1st FIS failed)
[65990.150343] ata10: hard resetting link
[66025.199406] ata10: softreset failed (1st FIS failed)
[66025.199417] ata10: hard resetting link
[66030.407703] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[66030.407713] ata10.00: link online but device misclassified
[66030.407746] ata10: EH complete
[66030.408360] sd 9:0:0:0: [sdg] tag#16 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.408363] sd 9:0:0:0: [sdg] tag#16 CDB: Write(16) 8a 00 00 00 00
00 09 a4 bf 80 00 00 49 80 00 00
[66030.408365] blk_update_request: I/O error, dev sdg, sector 161791872
[66030.408369] BTRFS: bdev /dev/sdg errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[66030.408439] BTRFS: bdev /dev/sdg errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[66030.408537] BTRFS: bdev /dev/sdg errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[66030.408643] BTRFS: bdev /dev/sdg errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[66030.408768] BTRFS: bdev /dev/sdg errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[66030.408880] BTRFS: bdev /dev/sdg errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
[66030.408985] BTRFS: bdev /dev/sdg errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
[66030.409082] BTRFS: bdev /dev/sdg errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
[66030.409180] BTRFS: bdev /dev/sdg errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
[66030.409284] BTRFS: bdev /dev/sdg errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
[66030.409847] sd 9:0:0:0: [sdg] tag#17 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.409850] sd 9:0:0:0: [sdg] tag#17 CDB: Write(16) 8a 00 00 00 00
00 09 a5 09 00 00 00 44 40 00 00
[66030.409851] blk_update_request: I/O error, dev sdg, sector 161810688
[66030.411235] sd 9:0:0:0: [sdg] tag#18 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.411238] sd 9:0:0:0: [sdg] tag#18 CDB: Write(16) 8a 00 00 00 00
00 09 a5 4d 40 00 00 49 80 00 00
[66030.411239] blk_update_request: I/O error, dev sdg, sector 161828160
[66030.412695] sd 9:0:0:0: [sdg] tag#19 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.412697] sd 9:0:0:0: [sdg] tag#19 CDB: Write(16) 8a 00 00 00 00
00 09 a5 96 c0 00 00 49 80 00 00
[66030.412699] blk_update_request: I/O error, dev sdg, sector 161846976
[66030.414113] sd 9:0:0:0: [sdg] tag#20 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.414115] sd 9:0:0:0: [sdg] tag#20 CDB: Write(16) 8a 00 00 00 00
00 09 a5 e0 40 00 00 1f 80 00 00
[66030.414117] blk_update_request: I/O error, dev sdg, sector 161865792
[66030.414755] sd 9:0:0:0: [sdg] tag#21 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.414758] sd 9:0:0:0: [sdg] tag#21 CDB: Write(16) 8a 00 00 00 00
00 09 a5 ff c0 00 00 15 00 00 00
[66030.414759] blk_update_request: I/O error, dev sdg, sector 161873856
[66030.415205] sd 9:0:0:0: [sdg] tag#22 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.415207] sd 9:0:0:0: [sdg] tag#22 CDB: Write(16) 8a 00 00 00 00
00 09 a6 14 c0 00 00 44 40 00 00
[66030.415208] blk_update_request: I/O error, dev sdg, sector 161879232
[66030.416562] sd 9:0:0:0: [sdg] tag#23 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.416564] sd 9:0:0:0: [sdg] tag#23 CDB: Write(16) 8a 00 00 00 00
00 09 a6 59 00 00 00 44 40 00 00
[66030.416572] blk_update_request: I/O error, dev sdg, sector 161896704
[66030.417922] sd 9:0:0:0: [sdg] tag#24 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.417924] sd 9:0:0:0: [sdg] tag#24 CDB: Write(16) 8a 00 00 00 00
00 09 a6 9d 40 00 00 49 80 00 00
[66030.417926] blk_update_request: I/O error, dev sdg, sector 161914176
[66030.419365] sd 9:0:0:0: [sdg] tag#25 FAILED Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[66030.419368] sd 9:0:0:0: [sdg] tag#25 CDB: Write(16) 8a 00 00 00 00
00 09 a6 e6 c0 00 00 49 80 00 00
[66030.419369] blk_update_request: I/O error, dev sdg, sector 161932992
[66031.291479] BTRFS: error (device sdb) in write_all_supers:3548:
errno=-5 IO failure (errors while submitting device barriers.)
[66031.291484] BTRFS info (device sdb): forced readonly
[66031.291487] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[66031.291489] ------------[ cut here ]------------
[66031.291505] WARNING: CPU: 5 PID: 11970 at
/build/linux-d3RvQM/linux-4.2.0/fs/btrfs/transaction.c:1710
cleanup_transaction+0x92/0x2f0 [btrfs]()
[66031.291507] BTRFS: Transaction aborted (error -5)
[66031.291508] Modules linked in: ipheth snd_seq_dummy rfcomm
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge
stp llc ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter ip_tables x_tables vmw_vsock_vmci_transport vsock
vmw_vmci snd_hrtimer binfmt_misc bnep ch341 usbserial eeepc_wmi
asus_wmi sparse_keymap video mxm_wmi crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd serio_raw fam15h_power edac_core k10temp
edac_mce_amd joydev input_leds btusb btrtl btbcm btintel bluetooth
snd_hdsp i2c_piix4 snd_ice1724 snd_ak4113 snd_pt2258 snd_ak4114
snd_i2c snd_ice17xx_ak4xxx snd_ak4xxx_adda
[66031.291541]  snd_ac97_codec ac97_bus snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_hwdep 8250_fintek tpm_infineon shpchp mac_hid wmi
kvm_amd kvm cuse snd_aloop snd_pcm snd_seq_midi snd_seq_midi_event
snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore parport_pc
ppdev lp parport autofs4 btrfs raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0
multipath linear hid_generic usbhid hid psmouse r8169 mii amdkfd
amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper drm ahci libahci
[66031.291569] CPU: 5 PID: 11970 Comm: btrfs-transacti Not tainted
4.2.0-17-lowlatency #21-Ubuntu
[66031.291570] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./SABERTOOTH 990FX R2.0, BIOS 1903 07/08/2013
[66031.291572]  0000000000000000 0000000094954717 ffff8803b162bc98
ffffffff817f5409
[66031.291574]  0000000000000000 ffff8803b162bcf0 ffff8803b162bcd8
ffffffff8107bed6
[66031.291576]  0000000000000246 ffff8803b1cd4d38 ffff8803d11de800
ffff8804178fc450
[66031.291578] Call Trace:
[66031.291583]  [<ffffffff817f5409>] dump_stack+0x4c/0x6e
[66031.291586]  [<ffffffff8107bed6>] warn_slowpath_common+0x86/0xc0
[66031.291588]  [<ffffffff8107bf65>] warn_slowpath_fmt+0x55/0x70
[66031.291598]  [<ffffffffc037aca2>] cleanup_transaction+0x92/0x2f0 [btrfs]
[66031.291601]  [<ffffffff810beb10>] ? wake_atomic_t_function+0x60/0x60
[66031.291611]  [<ffffffffc037c117>]
btrfs_commit_transaction+0xa07/0xb20 [btrfs]
[66031.291620]  [<ffffffffc0376da3>] transaction_kthread+0x1c3/0x230 [btrfs]
[66031.291629]  [<ffffffffc0376be0>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[66031.291631]  [<ffffffff8109b908>] kthread+0xd8/0xf0
[66031.291633]  [<ffffffff8109b830>] ? kthread_worker_fn+0x170/0x170
[66031.291635]  [<ffffffff817fc9df>] ret_from_fork+0x3f/0x70
[66031.291637]  [<ffffffff8109b830>] ? kthread_worker_fn+0x170/0x170
[66031.291638] ---[ end trace c69e578c3752000c ]---
[66031.291640] BTRFS: error (device sdb) in cleanup_transaction:1710:
errno=-5 IO failure
[66031.291642] BTRFS info (device sdb): delayed_refs has NO entry
[66031.292522] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[66031.292527] BTRFS: error (device sdb) in cleanup_transaction:1710:
errno=-5 IO failure
[66031.292530] BTRFS info (device sdb): delayed_refs has NO entry
[66031.292659] BTRFS: error (device sdb) in __cancel_balance:3452:
errno=-5 IO failure
