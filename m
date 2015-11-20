Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36244 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbbKTELH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 23:11:07 -0500
Received: by pacdm15 with SMTP id dm15so103052703pac.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 20:11:07 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Paul Loewenstein <paul.loewenstein@gmail.com>
Subject: Self-destruct of btrfs RAID6 array
Message-ID: <564E9D62.4050306@gmail.com>
Date: Thu, 19 Nov 2015 20:11:14 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have just had an apparently catastrophic collapse of a large RAID6 
array.  I was hoping that the dual-redundancy of a RAID6 array would 
compensate for having no backup media large enough to back it up!

Any suggestions for repairing this array, at least to the point of 
mounting it read-only?  I am thinking of trying to mount it degraded 
with different devices missing, but I don't know if that will be an 
exercise in futility.

btrfs fi show still works!

Label: 'btrfsdata'  uuid: ccde0a00-e50b-4154-977f-ac591ab580a5
         Total devices 6 FS bytes used 9.62TiB
         devid   10 size 3.64TiB used 2.41TiB path /dev/sdg
         devid   11 size 3.64TiB used 2.41TiB path /dev/sda
         devid   12 size 3.64TiB used 2.41TiB path /dev/sdb
         devid   13 size 3.64TiB used 2.41TiB path /dev/sdc
         devid   14 size 3.64TiB used 2.41TiB path /dev/sdd
         devid   15 size 3.64TiB used 2.41TiB path /dev/sde

It spontaneously (I believe it was after it successfully mounted rw on 
boot, but I can't check for sure without looking at the last file 
creation time).  After another reboot it won't mount at all.

btrfs check /dev/sda gives:

parent transid verify failed on 73440384909312 wanted 491976 found 485531
parent transid verify failed on 73440384909312 wanted 491976 found 485531
checksum verify failed on 73440384909312 found 26943E11 wanted 0FCB3E97
checksum verify failed on 73440384909312 found AAD98681 wanted EA004FE8
checksum verify failed on 73440384909312 found AAD98681 wanted EA004FE8
bytenr mismatch, want=73440384909312, have=274180945215488
Couldn't read chunk root
Couldn't open file system

Looking back in the journal (I shall now be setting up journal 
monitoring), I found lots of errors, starting last September, only a few 
weeks after converting from RAID1 to RAID6.
Blank lines precede reboots and for the first log indicate the omission 
of over 30K entries!  The first log must represent some software bug, 
because /dev/sdh is NOT a btrfs device!

LOG EXTRACTS, while the filesystem was still mounted.  Journal grepped 
for btrfs, boot line added after.  Note different kernel version on 
reboot after upgrade.

Aug 26 20:12:24 cambridge kernel: Linux version 4.1.5-100.fc21.x86_64 
(mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 4.9.2 20150212 
(Red Hat 4.9.2-6) (GCC) ) #1 SMP Tue Aug 11 00:24:23 UTC 2015
Aug 26 20:12:52 cambridge kernel: Btrfs loaded
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 11 
transid 484422 /dev/sda
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 15 
transid 484422 /dev/sde
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 13 
transid 484422 /dev/sdc
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 14 
transid 484422 /dev/sdd
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 12 
transid 484422 /dev/sdb
Aug 26 20:12:52 cambridge kernel: BTRFS: device label btrfsdata devid 10 
transid 484422 /dev/sdg
Sep 13 16:11:34 cambridge kernel: BTRFS: bdev /dev/sdh errs: wr 0, rd 0, 
flush 1, corrupt 0, gen 0
Sep 13 16:11:34 cambridge kernel: BTRFS: lost page write due to I/O 
error on /dev/sdh
Sep 13 16:11:34 cambridge kernel: BTRFS: bdev /dev/sdh errs: wr 1, rd 0, 
flush 1, corrupt 0, gen 0
Sep 13 16:11:34 cambridge kernel: BTRFS: lost page write due to I/O 
error on /dev/sdh
Sep 13 16:11:34 cambridge kernel: BTRFS: bdev /dev/sdh errs: wr 2, rd 0, 
flush 1, corrupt 0, gen 0
Sep 13 16:11:34 cambridge kernel: BTRFS: lost page write due to I/O 
error on /dev/sdh

Nov 15 15:21:51 cambridge kernel: BTRFS: lost page write due to I/O 
error on /dev/sdh
Nov 15 15:21:51 cambridge kernel: BTRFS: bdev /dev/sdh errs: wr 18713, 
rd 0, flush 6238, corrupt 0, gen 0
Nov 15 15:21:51 cambridge kernel: BTRFS: lost page write due to I/O 
error on /dev/sdh
Nov 15 15:21:51 cambridge kernel: BTRFS: bdev /dev/sdh errs: wr 18714, 
rd 0, flush 6238, corrupt 0, gen 0

Nov 15 15:23:00 cambridge kernel: Linux version 4.1.12-101.fc21.x86_64 
(mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 4.9.2 20150212 
(Red Hat 4.9.2-6) (GCC) ) #1 SMP Wed Oct 28 15:18:44 UTC 2015
Nov 15 15:23:33 cambridge kernel: Btrfs loaded
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 14 
transid 492036 /dev/sdd
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 15 
transid 485798 /dev/sde
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 11 
transid 492036 /dev/sda
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 13 
transid 492036 /dev/sdc
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 10 
transid 492036 /dev/sdg
Nov 15 15:23:33 cambridge kernel: BTRFS: device label btrfsdata devid 12 
transid 492036 /dev/sdb
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384909312 wanted 491976 found 485531
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384913408 wanted 491976 found 485531
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 15:23:33 cambridge kernel: BTRFS: bdev /dev/sde errs: wr 18711, 
rd 0, flush 6237, corrupt 0, gen 0
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): bad tree block 
start 1121375725894905312 74200909787136
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): bad tree block 
start 7250342666203184288 74200909791232
Nov 15 15:23:33 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439

Nov 15 20:37:14 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 20:37:14 cambridge kernel: BTRFS (device sdb): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 20:39:01 cambridge kernel: BTRFS (device sdb): bad tree block 
start 8747312261073978676 74201584123904
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733865472 csum 3128256294 expected csum 3176585556
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733869568 csum 3953187115 expected csum 2827150008
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733873664 csum 2011708136 expected csum 1514290758
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733877760 csum 4227108651 expected csum 3929632885
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733881856 csum 667263525 expected csum 2167952522
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733885952 csum 1421670165 expected csum 2602382287
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733890048 csum 2320260888 expected csum 606775819
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733865472 csum 3128256294 expected csum 3176585556
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733894144 csum 2140326945 expected csum 2209619790
Nov 15 20:39:02 cambridge kernel: BTRFS warning (device sdb): csum 
failed ino 1455165 off 1733898240 csum 372680472 expected csum 3888049973

Nov 15 20:42:45 cambridge kernel: Linux version 4.1.12-101.fc21.x86_64 
(mockbuild@bkernel01.phx2.fedoraproject.org) (gcc version 4.9.2 20150212 
(Red Hat 4.9.2-6) (GCC) ) #1 SMP Wed Oct 28 15:18:44 UTC 2015
Nov 15 20:43:16 cambridge kernel: Btrfs loaded
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 15 
transid 492120 /dev/sde
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 14 
transid 492120 /dev/sdd
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 13 
transid 492120 /dev/sdc
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 12 
transid 492120 /dev/sdb
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 11 
transid 492120 /dev/sda
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 10 
transid 492120 /dev/sdg
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384909312 wanted 491976 found 485531
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384913408 wanted 491976 found 485531
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 20:43:16 cambridge kernel: BTRFS: bdev /dev/sde errs: wr 18711, 
rd 0, flush 6237, corrupt 0, gen 0
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 1121375725894905312 74200909787136
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 7250342666203184288 74200909791232
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS: Failed to read block groups: -5
Nov 15 20:43:16 cambridge kernel: BTRFS: open_ctree failed
Nov 15 20:49:14 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384909312 wanted 491976 found 485531
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384913408 wanted 491976 found 485531
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 20:49:15 cambridge kernel: BTRFS: bdev /dev/sde errs: wr 18711, 
rd 0, flush 6237, corrupt 0, gen 0
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 1121375725894905312 74200909787136
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 7250342666203184288 74200909791232
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS: Failed to read block groups: -5
Nov 15 20:49:16 cambridge kernel: BTRFS: open_ctree failed
Nov 15 20:43:16 cambridge kernel: Btrfs loaded
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 15 
transid 492120 /dev/sde
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 14 
transid 492120 /dev/sdd
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 13 
transid 492120 /dev/sdc
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 12 
transid 492120 /dev/sdb
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 11 
transid 492120 /dev/sda
Nov 15 20:43:16 cambridge kernel: BTRFS: device label btrfsdata devid 10 
transid 492120 /dev/sdg
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384909312 wanted 491976 found 485531
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384913408 wanted 491976 found 485531
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 20:43:16 cambridge kernel: BTRFS: bdev /dev/sde errs: wr 18711, 
rd 0, flush 6237, corrupt 0, gen 0
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 1121375725894905312 74200909787136
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 7250342666203184288 74200909791232
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:43:16 cambridge kernel: BTRFS: Failed to read block groups: -5
Nov 15 20:43:16 cambridge kernel: BTRFS: open_ctree failed
Nov 15 20:49:14 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384909312 wanted 491976 found 485531
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384913408 wanted 491976 found 485531
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384917504 wanted 491976 found 485696
Nov 15 20:49:15 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73440384921600 wanted 491976 found 485696
Nov 15 20:49:15 cambridge kernel: BTRFS: bdev /dev/sde errs: wr 18711, 
rd 0, flush 6237, corrupt 0, gen 0
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 1121375725894905312 74200909787136
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): bad tree block 
start 7250342666203184288 74200909791232
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS (device sdg): parent transid 
verify failed on 73417618042880 wanted 488487 found 485439
Nov 15 20:49:16 cambridge kernel: BTRFS: Failed to read block groups: -5
Nov 15 20:49:16 cambridge kernel: BTRFS: open_ctree failed

