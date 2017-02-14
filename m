Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:15636 "EHLO smtp209.alice.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754359AbdBNPlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 10:41:22 -0500
To: linux-btrfs@vger.kernel.org
From: A Mennucc <debdev@flip.selfip.org>
Subject: problem: can't mount superblock
Message-ID: <e4124318-71c7-0a3f-b09f-1fef340f4e63@mennucc1.debian.net>
Date: Tue, 14 Feb 2017 16:34:41 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="0X6OHERewMPUfik7Shn3LaTXsh01FJvt4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0X6OHERewMPUfik7Shn3LaTXsh01FJvt4
Content-Type: multipart/mixed; boundary="Wk55NMQUIbgbSCIRFIRCNuSCgnnDWtspe";
 protected-headers="v1"
From: A Mennucc <debdev@mennucc1.debian.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <e4124318-71c7-0a3f-b09f-1fef340f4e63@mennucc1.debian.net>
Subject: problem: can't mount superblock

--Wk55NMQUIbgbSCIRFIRCNuSCgnnDWtspe
Content-Type: multipart/mixed;
 boundary="------------41CBFE2E3E52B116D7BE0F4F"

This is a multi-part message in MIME format.
--------------41CBFE2E3E52B116D7BE0F4F
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

dear all,

two days ago I got an old 1TB external USB HDD drive.  I scanned it
using smartctl, long scan, no errors.  I created one partition
/dev/sde1, formatted it using BTRFS, and created two subvolumes. One
subvolume was intended for backups.  This morning I started copying some
200GB data on this subvolume, but something went haywire.

I use Ubuntu xenial + backports,
linux kernel 4.8.0-34-generic
btrfs-progs               4.7.3-1

I now see that in the kernel log this line was printed many times

> BTRFS error (device sdd1): bdev /dev/sdd1 errs: wr **, rd 0, flush 0,
> corrupt 0, gen 0
where ** progressed from 0 to 56; after that this line appeared

> BTRFS: error (device sdd1) in btrfs_commit_transaction:2232: errno=3D-5=

> IO failure (Error while writing out transaction)
> BTRFS info (device sdd1): forced readonly
then there was a traceback, and a lot more errors (see attached log).

I then umounted the volume, but I could not remount it. (Yes I tried to
turn it off and on again).

Here are some command and their outputs.

> # mount -t btrfs -o ro,recover /dev/sde1 /mnt
> mount: /dev/sde1: can't read superblock
when I run the above, The kernel log reports
> BTRFS error (device sdd1): bdev /dev/sde1 errs: wr 73, rd 44, flush 0,
> corrupt 0, gen 0
where the "rd" part increases each time

Another command.
> # btrfs check --repair /dev/sde1
> enabling repair mode
> Checking filesystem on /dev/sde1
> UUID: 491f1bb6-a477-4f3d-a066-111119cabaa9
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated=

> checking fs roots
> checking csums
> checking root refs
> found 90068570112 bytes used err is 0
> total csum bytes: 87728132
> total tree bytes: 212680704
> total fs tree bytes: 110411776
> total extent tree bytes: 5750784
> btree space waste bytes: 23630000
> file data blocks allocated: 89855889408
>  referenced 89855889408

Note that smartctl reports no errors in the HDD  whatsoever... (
whatever error occurred, it was maybe in the USB transport).

Maybe the next step may be  "btrfs rescue super-recover" but I would
like your advice.

Thanks, a.

ps: please reply to me too, I did not subscribe to this list


--------------41CBFE2E3E52B116D7BE0F4F
Content-Type: text/x-log;
 name="kern.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kern.log"

Feb 14 09:36:34 localhost kernel: [431222.636024] usb 1-3: new high-speed=
 USB device number 3 using ehci-pci
Feb 14 09:36:34 localhost kernel: [431222.785672] usb 1-3: New USB device=
 found, idVendor=3D0bc2, idProduct=3D2321
Feb 14 09:36:34 localhost kernel: [431222.785675] usb 1-3: New USB device=
 strings: Mfr=3D2, Product=3D3, SerialNumber=3D1
Feb 14 09:36:34 localhost kernel: [431222.785676] usb 1-3: Product: Expan=
sion
Feb 14 09:36:34 localhost kernel: [431222.785678] usb 1-3: Manufacturer: =
Seagate
Feb 14 09:36:34 localhost kernel: [431222.785679] usb 1-3: SerialNumber: =
NA4BS1FY
Feb 14 09:36:34 localhost kernel: [431222.787890] scsi host7: uas
Feb 14 09:36:34 localhost kernel: [431222.824806] sd 7:0:0:0: Attached sc=
si generic sg5 type 0
Feb 14 09:36:34 localhost kernel: [431222.825556] sd 7:0:0:0: [sde] Spinn=
ing up disk...
Feb 14 09:36:37 localhost kernel: [431223.840036] ...ready
Feb 14 09:36:37 localhost kernel: [431225.888521] sd 7:0:0:0: [sde] 39070=
29167 512-byte logical blocks: (2.00 TB/1.82 TiB)
Feb 14 09:36:37 localhost kernel: [431225.888524] sd 7:0:0:0: [sde] 2048-=
byte physical blocks
Feb 14 09:36:37 localhost kernel: [431226.167318] sd 7:0:0:0: [sde] Attac=
hed SCSI disk
Feb 14 09:38:19 localhost kernel: [431327.955353] EXT4-fs (sde1): mounted=
 filesystem with ordered data mode. Opts: (null)
Feb 14 10:19:00 localhost kernel: [433769.032880] floppy: error -5 while =
reading block 0
Feb 14 10:19:21 localhost kernel: [433789.768849] blk_update_request: I/O=
 error, dev fd0, sector 0
Feb 14 10:19:21 localhost kernel: [433789.768873] floppy: error -5 while =
reading block 0
Feb 14 10:19:27 localhost kernel: [433796.434449] blk_update_request: I/O=
 error, dev sdd, sector 65435512
Feb 14 10:19:28 localhost kernel: [433796.774734] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:28 localhost kernel: [433796.774740] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 7a 30 00 00 f0 00
Feb 14 10:19:28 localhost kernel: [433796.774743] blk_update_request: I/O=
 error, dev sdd, sector 65436208
Feb 14 10:19:28 localhost kernel: [433797.007909] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:28 localhost kernel: [433797.007916] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 7c 10 00 00 f0 00
Feb 14 10:19:28 localhost kernel: [433797.007919] blk_update_request: I/O=
 error, dev sdd, sector 65436688
Feb 14 10:19:28 localhost kernel: [433797.230799] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:28 localhost kernel: [433797.230805] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 7d f0 00 00 f0 00
Feb 14 10:19:28 localhost kernel: [433797.230808] blk_update_request: I/O=
 error, dev sdd, sector 65437168
Feb 14 10:19:28 localhost kernel: [433797.341397] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:28 localhost kernel: [433797.341403] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 7e e0 00 00 f0 00
Feb 14 10:19:28 localhost kernel: [433797.341406] blk_update_request: I/O=
 error, dev sdd, sector 65437408
Feb 14 10:19:29 localhost kernel: [433797.658485] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:29 localhost kernel: [433797.658491] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 81 40 00 00 f0 00
Feb 14 10:19:29 localhost kernel: [433797.774383] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:29 localhost kernel: [433797.774389] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 82 30 00 00 f0 00
Feb 14 10:19:29 localhost kernel: [433797.894652] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:19:29 localhost kernel: [433797.894658] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 03 e6 83 20 00 00 f0 00
Feb 14 10:19:30 localhost kernel: [433798.748936] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 16, rd 0, flush 0, corrupt 0, gen 0
Feb 14 10:49:28 localhost kernel: [435596.923205] scsi_io_completion: 7 c=
allbacks suppressed
Feb 14 10:49:28 localhost kernel: [435596.923215] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:49:28 localhost kernel: [435596.923219] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 07 5f 8e 60 00 00 f0 00
Feb 14 10:49:28 localhost kernel: [435596.923220] blk_update_request: 11 =
callbacks suppressed
Feb 14 10:49:28 localhost kernel: [435596.923222] blk_update_request: I/O=
 error, dev sdd, sector 123702880
Feb 14 10:49:28 localhost kernel: [435597.035855] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 07 5f 8f 50 00 00 f0 00
Feb 14 10:49:28 localhost kernel: [435597.035858] blk_update_request: I/O=
 error, dev sdd, sector 123703120
Feb 14 10:49:28 localhost kernel: [435597.146480] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:49:28 localhost kernel: [435597.146489] blk_update_request: I/O=
 error, dev sdd, sector 123703360
Feb 14 10:49:28 localhost kernel: [435597.459717] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 17, rd 0, flush 0, corrupt 0, gen 0
Feb 14 10:49:32 localhost kernel: [435601.405993] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 21, rd 0, flush 0, corrupt 0, gen 0
Feb 14 10:49:32 localhost kernel: [435601.406190] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 22, rd 0, flush 0, corrupt 0, gen 0
Feb 14 10:49:33 localhost kernel: [435601.983477] blk_update_request: 36 =
callbacks suppressed
Feb 14 10:49:33 localhost kernel: [435602.094483] blk_update_request: I/O=
 error, dev sdd, sector 123713664
Feb 14 10:49:33 localhost kernel: [435602.529664] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:49:33 localhost kernel: [435602.529670] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 07 5f bb d0 00 00 f0 00
Feb 14 10:49:33 localhost kernel: [435602.529673] blk_update_request: I/O=
 error, dev sdd, sector 123714512
Feb 14 10:49:38 localhost kernel: [435607.091341] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:49:38 localhost kernel: [435607.091346] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 07 5f e7 90 00 00 f0 00
Feb 14 10:49:38 localhost kernel: [435607.091348] blk_update_request: I/O=
 error, dev sdd, sector 123725712
Feb 14 10:49:39 localhost kernel: [435607.679431] blk_update_request: I/O=
 error, dev sdd, sector 123727280
Feb 14 10:49:39 localhost kernel: [435607.763439] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 10:49:39 localhost kernel: [435607.763444] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 07 5f ee a0 00 00 f0 00
Feb 14 10:49:39 localhost kernel: [435607.763446] blk_update_request: I/O=
 error, dev sdd, sector 123727520
Feb 14 11:16:22 localhost kernel: [437211.349874] usb 1-8: New USB device=
 found, idVendor=3D1bbb, idProduct=3D0168
Feb 14 11:16:22 localhost kernel: [437211.349877] usb 1-8: New USB device=
 strings: Mfr=3D2, Product=3D3, SerialNumber=3D4
Feb 14 11:16:22 localhost kernel: [437211.349879] usb 1-8: Product: Wind =
Smart
Feb 14 11:16:22 localhost kernel: [437211.349880] usb 1-8: Manufacturer: =
MediaTek
Feb 14 11:16:22 localhost kernel: [437211.349882] usb 1-8: SerialNumber: =
NBFQS8ROOVEUTSSG
Feb 14 11:19:28 localhost kernel: [437396.858479] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:28 localhost kernel: [437396.858484] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a d9 a4 a8 00 00 f0 00
Feb 14 11:19:28 localhost kernel: [437396.858487] blk_update_request: I/O=
 error, dev sdd, sector 182035624
Feb 14 11:19:28 localhost kernel: [437396.970370] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:28 localhost kernel: [437396.970376] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a d9 a5 98 00 00 f0 00
Feb 14 11:19:28 localhost kernel: [437396.970379] blk_update_request: I/O=
 error, dev sdd, sector 182035864
Feb 14 11:19:28 localhost kernel: [437397.083398] blk_update_request: I/O=
 error, dev sdd, sector 182036104
Feb 14 11:19:28 localhost kernel: [437397.180444] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:28 localhost kernel: [437397.180451] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a d9 a7 78 00 00 80 00
Feb 14 11:19:28 localhost kernel: [437397.180454] blk_update_request: I/O=
 error, dev sdd, sector 182036344
Feb 14 11:19:28 localhost kernel: [437397.295795] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:28 localhost kernel: [437397.295800] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a d9 a7 f8 00 00 f0 00
Feb 14 11:19:28 localhost kernel: [437397.295803] blk_update_request: I/O=
 error, dev sdd, sector 182036472
Feb 14 11:19:33 localhost kernel: [437401.622813] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:33 localhost kernel: [437401.622817] blk_update_request: 38 =
callbacks suppressed
Feb 14 11:19:33 localhost kernel: [437401.803464] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:33 localhost kernel: [437401.803469] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a d9 ce 88 00 00 f0 00
Feb 14 11:19:33 localhost kernel: [437401.803472] blk_update_request: I/O=
 error, dev sdd, sector 182046344
Feb 14 11:19:34 localhost kernel: [437402.701973] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 40, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:34 localhost kernel: [437403.474087] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 41, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:35 localhost kernel: [437404.241949] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 42, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:37 localhost kernel: [437405.770053] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 44, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:38 localhost kernel: [437406.538043] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 45, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:38 localhost kernel: [437406.714822] scsi_io_completion: 49 =
callbacks suppressed
Feb 14 11:19:38 localhost kernel: [437406.714829] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:38 localhost kernel: [437406.714833] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 00 e8 00 00 f0 00
Feb 14 11:19:38 localhost kernel: [437406.714834] blk_update_request: 49 =
callbacks suppressed
Feb 14 11:19:38 localhost kernel: [437406.714836] blk_update_request: I/O=
 error, dev sdd, sector 182059240
Feb 14 11:19:38 localhost kernel: [437406.803457] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:38 localhost kernel: [437406.803460] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 01 d8 00 00 f0 00
Feb 14 11:19:38 localhost kernel: [437406.803462] blk_update_request: I/O=
 error, dev sdd, sector 182059480
Feb 14 11:19:38 localhost kernel: [437406.978364] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:38 localhost kernel: [437406.978369] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 03 b8 00 00 90 00
Feb 14 11:19:38 localhost kernel: [437406.978372] blk_update_request: I/O=
 error, dev sdd, sector 182059960
Feb 14 11:19:38 localhost kernel: [437406.979668] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 46, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:38 localhost kernel: [437407.243522] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:38 localhost kernel: [437407.243525] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 06 28 00 00 f0 00
Feb 14 11:19:38 localhost kernel: [437407.243527] blk_update_request: I/O=
 error, dev sdd, sector 182060584
Feb 14 11:19:38 localhost kernel: [437407.335668] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:38 localhost kernel: [437407.335674] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 07 18 00 00 f0 00
Feb 14 11:19:38 localhost kernel: [437407.335676] blk_update_request: I/O=
 error, dev sdd, sector 182060824
Feb 14 11:19:39 localhost kernel: [437407.769981] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 47, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:40 localhost kernel: [437408.790136] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 48, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:41 localhost kernel: [437409.553996] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 49, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:41 localhost kernel: [437410.321987] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 50, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:42 localhost kernel: [437411.086740] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 51, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:42 localhost kernel: [437411.515420] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 52, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:42 localhost kernel: [437411.516746] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 53, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:43 localhost kernel: [437411.597552] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 54, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:43 localhost kernel: [437411.683313] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 55, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:43 localhost kernel: [437411.684579] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 56, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:43 localhost kernel: [437411.685832] BTRFS: error (device sd=
d1) in btrfs_commit_transaction:2232: errno=3D-5 IO failure (Error while =
writing out transaction)
Feb 14 11:19:43 localhost kernel: [437411.686196] BTRFS info (device sdd1=
): forced readonly
Feb 14 11:19:43 localhost kernel: [437411.686198] BTRFS warning (device s=
dd1): Skipping commit of aborted transaction.
Feb 14 11:19:43 localhost kernel: [437411.686200] ------------[ cut here =
]------------
Feb 14 11:19:43 localhost kernel: [437411.686256] WARNING: CPU: 0 PID: 16=
232 at /build/linux-hwe-edge-V64a3L/linux-hwe-edge-4.8.0/fs/btrfs/transac=
tion.c:1854 cleanup_transaction+0x8e/0x2f0 [btrfs]
Feb 14 11:19:43 localhost kernel: [437411.686257] BTRFS: Transaction abor=
ted (error -5)
Feb 14 11:19:43 localhost kernel: [437411.686258] Modules linked in: veth=
 xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable=
_filter xt_nat xt_tcpudp iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_=
nat_ipv4 nf_nat nf_conntrack ip_tables x_tables bridge stp llc binfmt_mis=
c snd_hda_codec_realtek kvm_amd snd_hda_codec_generic kvm irqbypass snd_h=
da_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm input_leds snd_time=
r snd soundcore serio_raw k8temp i2c_piix4 asus_atk0110 shpchp mac_hid au=
tofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_=
xor async_tx xor raid6_pq libcrc32c raid0 multipath linear raid1 pata_acp=
i uas usb_storage nouveau mxm_wmi wmi video i2c_algo_bit ttm drm_kms_help=
er psmouse syscopyarea sysfillrect sysimgblt fb_sys_fops floppy drm fjes =
pata_atiixp atl1 ahci mii libahci
Feb 14 11:19:43 localhost kernel: [437411.686301] CPU: 0 PID: 16232 Comm:=
 btrfs-transacti Not tainted 4.8.0-34-generic #36~16.04.1-Ubuntu
Feb 14 11:19:43 localhost kernel: [437411.686302] Hardware name: System m=
anufacturer System Product Name/M3A, BIOS 1206    06/11/2010
Feb 14 11:19:43 localhost kernel: [437411.686304]  0000000000000286 00000=
0003c0f4b53 ffff8df0f69dfce0 ffffffffb722d7b3
Feb 14 11:19:43 localhost kernel: [437411.686307]  ffff8df0f69dfd30 00000=
00000000000 ffff8df0f69dfd20 ffffffffb6e8313b
Feb 14 11:19:43 localhost kernel: [437411.686309]  0000073ec06756c6 ffff8=
df0c289d0e0 ffff8df0fbdbb800 ffff8df0c283cb40
Feb 14 11:19:43 localhost kernel: [437411.686311] Call Trace:
Feb 14 11:19:43 localhost kernel: [437411.686317]  [<ffffffffb722d7b3>] d=
ump_stack+0x63/0x90
Feb 14 11:19:43 localhost kernel: [437411.686321]  [<ffffffffb6e8313b>] _=
_warn+0xcb/0xf0
Feb 14 11:19:43 localhost kernel: [437411.686323]  [<ffffffffb6e831bf>] w=
arn_slowpath_fmt+0x5f/0x80
Feb 14 11:19:43 localhost kernel: [437411.686349]  [<ffffffffc05eacfe>] c=
leanup_transaction+0x8e/0x2f0 [btrfs]
Feb 14 11:19:43 localhost kernel: [437411.686352]  [<ffffffffb6ec74d0>] ?=
 wake_atomic_t_function+0x60/0x60
Feb 14 11:19:43 localhost kernel: [437411.686354]  [<ffffffffb6ec6e84>] ?=
 __wake_up+0x44/0x50
Feb 14 11:19:43 localhost kernel: [437411.686379]  [<ffffffffc05ec950>] b=
trfs_commit_transaction+0x2e0/0xb00 [btrfs]
Feb 14 11:19:43 localhost kernel: [437411.686404]  [<ffffffffc05e7251>] t=
ransaction_kthread+0x1f1/0x210 [btrfs]
Feb 14 11:19:43 localhost kernel: [437411.686429]  [<ffffffffc05e7060>] ?=
 btrfs_cleanup_transaction+0x590/0x590 [btrfs]
Feb 14 11:19:43 localhost kernel: [437411.686432]  [<ffffffffb6ea4008>] k=
thread+0xd8/0xf0
Feb 14 11:19:43 localhost kernel: [437411.686437]  [<ffffffffb769679f>] r=
et_from_fork+0x1f/0x40
Feb 14 11:19:43 localhost kernel: [437411.686439]  [<ffffffffb6ea3f30>] ?=
 kthread_create_on_node+0x1e0/0x1e0
Feb 14 11:19:43 localhost kernel: [437411.686441] ---[ end trace cae466c5=
763973dd ]---
Feb 14 11:19:43 localhost kernel: [437411.686443] BTRFS: error (device sd=
d1) in cleanup_transaction:1854: errno=3D-5 IO failure
Feb 14 11:19:43 localhost kernel: [437411.686754] BTRFS info (device sdd1=
): delayed_refs has NO entry
Feb 14 11:19:43 localhost kernel: [437412.082379] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:43 localhost kernel: [437412.082384] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 32 d8 00 00 f0 00
Feb 14 11:19:43 localhost kernel: [437412.082387] blk_update_request: I/O=
 error, dev sdd, sector 182072024
Feb 14 11:19:44 localhost kernel: [437412.626585] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:44 localhost kernel: [437412.626590] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 37 18 00 00 f0 00
Feb 14 11:19:44 localhost kernel: [437412.626593] blk_update_request: I/O=
 error, dev sdd, sector 182073112
Feb 14 11:19:44 localhost kernel: [437412.741607] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:44 localhost kernel: [437412.741612] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 38 08 00 00 f0 00
Feb 14 11:19:44 localhost kernel: [437412.741615] blk_update_request: I/O=
 error, dev sdd, sector 182073352
Feb 14 11:19:44 localhost kernel: [437413.167537] btrfs_dev_stat_print_on=
_error: 1 callbacks suppressed
Feb 14 11:19:44 localhost kernel: [437413.167543] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 58, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:45 localhost kernel: [437414.165566] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 59, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:45 localhost kernel: [437414.166968] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 60, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:46 localhost kernel: [437415.147839] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 61, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:47 localhost kernel: [437416.119608] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 62, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:48 localhost kernel: [437416.789583] scsi_io_completion: 36 =
callbacks suppressed
Feb 14 11:19:48 localhost kernel: [437416.789591] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437416.789595] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 59 48 00 00 f0 00
Feb 14 11:19:48 localhost kernel: [437416.789596] blk_update_request: 36 =
callbacks suppressed
Feb 14 11:19:48 localhost kernel: [437416.789597] blk_update_request: I/O=
 error, dev sdd, sector 182081864
Feb 14 11:19:48 localhost kernel: [437416.901603] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437416.901607] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 5a 38 00 00 f0 00
Feb 14 11:19:48 localhost kernel: [437416.901610] blk_update_request: I/O=
 error, dev sdd, sector 182082104
Feb 14 11:19:48 localhost kernel: [437417.010370] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437417.010375] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 5b 28 00 00 f0 00
Feb 14 11:19:48 localhost kernel: [437417.010377] blk_update_request: I/O=
 error, dev sdd, sector 182082344
Feb 14 11:19:48 localhost kernel: [437417.214524] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437417.214531] blk_update_request: I/O=
 error, dev sdd, sector 182082712
Feb 14 11:19:48 localhost kernel: [437417.326548] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437417.326553] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 5d 88 00 00 f0 00
Feb 14 11:19:48 localhost kernel: [437417.326556] blk_update_request: I/O=
 error, dev sdd, sector 182082952
Feb 14 11:19:48 localhost kernel: [437417.440191] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:48 localhost kernel: [437417.440197] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 5e 78 00 00 f0 00
Feb 14 11:19:48 localhost kernel: [437417.440200] blk_update_request: I/O=
 error, dev sdd, sector 182083192
Feb 14 11:19:49 localhost kernel: [437417.550458] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:49 localhost kernel: [437417.550463] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 5f 68 00 00 f0 00
Feb 14 11:19:49 localhost kernel: [437417.550466] blk_update_request: I/O=
 error, dev sdd, sector 182083432
Feb 14 11:19:49 localhost kernel: [437417.661597] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:49 localhost kernel: [437417.661602] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 60 58 00 00 f0 00
Feb 14 11:19:49 localhost kernel: [437417.661605] blk_update_request: I/O=
 error, dev sdd, sector 182083672
Feb 14 11:19:49 localhost kernel: [437417.774741] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:49 localhost kernel: [437417.774746] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 61 48 00 00 f0 00
Feb 14 11:19:49 localhost kernel: [437417.774749] blk_update_request: I/O=
 error, dev sdd, sector 182083912
Feb 14 11:19:49 localhost kernel: [437418.091662] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 64, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:50 localhost kernel: [437419.071552] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 65, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:51 localhost kernel: [437420.052324] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 66, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:52 localhost kernel: [437421.027470] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 67, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:53 localhost kernel: [437421.815717] scsi_io_completion: 36 =
callbacks suppressed
Feb 14 11:19:53 localhost kernel: [437421.815726] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:53 localhost kernel: [437421.815730] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 82 38 00 00 f0 00
Feb 14 11:19:53 localhost kernel: [437421.815731] blk_update_request: 36 =
callbacks suppressed
Feb 14 11:19:53 localhost kernel: [437421.815732] blk_update_request: I/O=
 error, dev sdd, sector 182092344
Feb 14 11:19:53 localhost kernel: [437422.040838] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 69, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:53 localhost kernel: [437422.269658] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:53 localhost kernel: [437422.269663] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 85 d8 00 00 f0 00
Feb 14 11:19:53 localhost kernel: [437422.269665] blk_update_request: I/O=
 error, dev sdd, sector 182093272
Feb 14 11:19:53 localhost kernel: [437422.381798] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:53 localhost kernel: [437422.381802] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 86 c8 00 00 f0 00
Feb 14 11:19:53 localhost kernel: [437422.381804] blk_update_request: I/O=
 error, dev sdd, sector 182093512
Feb 14 11:19:53 localhost kernel: [437422.494569] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:53 localhost kernel: [437422.494573] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 87 b8 00 00 f0 00
Feb 14 11:19:53 localhost kernel: [437422.494576] blk_update_request: I/O=
 error, dev sdd, sector 182093752
Feb 14 11:19:54 localhost kernel: [437422.606959] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:54 localhost kernel: [437422.606964] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 88 a8 00 00 f0 00
Feb 14 11:19:54 localhost kernel: [437422.606966] blk_update_request: I/O=
 error, dev sdd, sector 182093992
Feb 14 11:19:54 localhost kernel: [437422.834868] sd 6:0:0:0: [sdd] tag#0=
 FAILED Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Feb 14 11:19:54 localhost kernel: [437422.834874] sd 6:0:0:0: [sdd] tag#0=
 CDB: Write(10) 2a 00 0a da 8a 88 00 00 f0 00
Feb 14 11:19:54 localhost kernel: [437422.834876] blk_update_request: I/O=
 error, dev sdd, sector 182094472
Feb 14 11:19:54 localhost kernel: [437423.044397] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 70, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:55 localhost kernel: [437424.030801] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 71, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:56 localhost kernel: [437425.007442] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 72, rd 0, flush 0, corrupt 0, gen 0
Feb 14 11:19:57 localhost kernel: [437425.743049] BTRFS error (device sdd=
1): bdev /dev/sdd1 errs: wr 73, rd 0, flush 0, corrupt 0, gen 0
Feb 14 12:08:34 localhost kernel: [440342.729711] sd 7:0:0:0: [sde] Synch=
ronizing SCSI cache
Feb 14 12:08:39 localhost kernel: [440348.509907] usb 1-4: USB disconnect=
, device number 2
Feb 14 12:09:04 localhost kernel: [440373.376848] scsi 7:0:0:0: Direct-Ac=
cess     Hitachi  HDT721010SLA360       PQ: 0 ANSI: 2 CCS
Feb 14 12:09:04 localhost kernel: [440373.377571] sd 7:0:0:0: Attached sc=
si generic sg4 type 0
Feb 14 12:09:04 localhost kernel: [440373.379338] sd 7:0:0:0: [sde] 19535=
25168 512-byte logical blocks: (1.00 TB/932 GiB)
Feb 14 12:09:04 localhost kernel: [440373.382499] sd 7:0:0:0: [sde] Write=
 Protect is off
Feb 14 12:09:04 localhost kernel: [440373.382504] sd 7:0:0:0: [sde] Mode =
Sense: 34 00 00 00
Feb 14 12:09:04 localhost kernel: [440373.383594] sd 7:0:0:0: [sde] Write=
 cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 14 12:09:04 localhost kernel: [440373.439495]  sde: sde1
Feb 14 12:09:23 localhost kernel: [440392.236026] BTRFS info (device sdd1=
): disk space caching is enabled
Feb 14 12:09:23 localhost kernel: [440392.236029] BTRFS error (device sdd=
1): Remounting read-write after error is not allowed
Feb 14 12:12:26 localhost kernel: [440574.893041] usb 1-4: USB disconnect=
, device number 5
Feb 14 12:12:41 localhost kernel: [440589.816598] blk_update_request: 24 =
callbacks suppressed
Feb 14 12:12:41 localhost kernel: [440589.816601] blk_update_request: I/O=
 error, dev fd0, sector 0
Feb 14 12:12:41 localhost kernel: [440589.816933] floppy: error -5 while =
reading block 0
Feb 14 12:12:53 localhost kernel: [440602.316544] blk_update_request: I/O=
 error, dev fd0, sector 0
Feb 14 12:12:53 localhost kernel: [440602.316868] floppy: error -5 while =
reading block 0
Feb 14 12:13:21 localhost kernel: [440630.464697] scsi 7:0:0:0: Direct-Ac=
cess     Hitachi  HDT721010SLA360       PQ: 0 ANSI: 2 CCS
Feb 14 12:13:21 localhost kernel: [440630.465228] sd 7:0:0:0: Attached sc=
si generic sg4 type 0
Feb 14 12:13:21 localhost kernel: [440630.472182] sd 7:0:0:0: [sde] Write=
 cache: disabled, read cache: enabled, doesn't support DPO or FUA
Feb 14 12:13:21 localhost kernel: [440630.530227]  sde: sde1
Feb 14 12:13:55 localhost kernel: [440664.028025] BTRFS info (device sdd1=
): disk space caching is enabled
Feb 14 12:13:55 localhost kernel: [440664.028028] BTRFS error (device sdd=
1): Remounting read-write after error is not allowed
Feb 14 12:14:22 localhost kernel: [440690.812024] BTRFS info (device sdd1=
): disk space caching is enabled
Feb 14 12:14:22 localhost kernel: [440690.812027] BTRFS error (device sdd=
1): Remounting read-write after error is not allowed
Feb 14 12:14:57 localhost kernel: [440725.883753] usb 1-8: USB disconnect=
, device number 4
Feb 14 15:32:35 localhost kernel: [452584.360024] BTRFS info (device sdd1=
): disk space caching is enabled
Feb 14 15:32:35 localhost kernel: [452584.360027] BTRFS error (device sdd=
1): Remounting read-write after error is not allowed
Feb 14 15:33:08 localhost kernel: [452616.900074] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 15, flush 0, corrupt 0, gen 0
Feb 14 15:33:08 localhost kernel: [452616.900446] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 16, flush 0, corrupt 0, gen 0
Feb 14 15:42:59 localhost kernel: [453208.436073] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 19, flush 0, corrupt 0, gen 0
Feb 14 15:42:59 localhost kernel: [453208.436430] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 20, flush 0, corrupt 0, gen 0
Feb 14 15:43:21 localhost kernel: [453230.448073] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 25, flush 0, corrupt 0, gen 0
Feb 14 15:43:21 localhost kernel: [453230.448435] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 26, flush 0, corrupt 0, gen 0
Feb 14 15:55:11 localhost kernel: [453939.768077] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 33, flush 0, corrupt 0, gen 0
Feb 14 15:55:11 localhost kernel: [453939.768432] BTRFS error (device sdd=
1): bdev /dev/sde1 errs: wr 73, rd 34, flush 0, corrupt 0, gen 0

--------------41CBFE2E3E52B116D7BE0F4F--

--Wk55NMQUIbgbSCIRFIRCNuSCgnnDWtspe--

--0X6OHERewMPUfik7Shn3LaTXsh01FJvt4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJYoyOVAAoJEFfM9FlqE1PCGrEP/AlCRWu5WnZqTs4Q6ASPORrT
SgcVWt3Z043jH2sin7GIn+/LRVdum8XaK+oqUuW57HC4LLipwsnea/jAcEoo3t+q
D8LcS9uE6GfI4I4OBeQIShZgjxKwM+gN+lp4XkkRwZc2CFl/qj2MokCYfPFoLATX
QAmNYwxtVonHkI0yybC1lMTivnvI3ciRR3MFImfirYYSvlftUn5Orf0sGEfTsA+Z
YJ58aNMElL9de/gUi8BDXtRHgufvvoimnwNQgfMR7zzAUiXWMJpG5xf9c0fCbETy
FuR7nEuI9VLYwRaZcTUW4vgWyAv5s2xO3ceoT4JZERJYm5QQC8vGueaFxLJmX0Wo
SIEY1Iasua9metC7rERMOBv3seKuu01K119F19Ct+WoimZcG6dcxX+Q3qhj9ympQ
nXCVxHE39VJvzosiuZrATTYwHptMoIAw2YpkTxad9VG/NBAcQl7rYf6uakiE6E4i
9N8CkcEa6Q/N9H/vmQslZSqIkHLyOg1UjZAfC4o81ET/ed9JjskSQWXUxzPtMk3/
z94H7jjG3RlP4Mx0WJAFDYEn5rEpDcMONia42uWgBaSCdaaUEQc5IGptlKVXhyxy
eqkKugbcns6j+GoEfD6ahiNZqZQiGAy7ee3Rtunh911JCXeYykW/2Osg+kHlf+Vp
HKUwOTfmq6cNkHSkeZbJ
=zdIc
-----END PGP SIGNATURE-----

--0X6OHERewMPUfik7Shn3LaTXsh01FJvt4--
